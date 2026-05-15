import json
import psycopg2
from psycopg2 import sql
from psycopg2.extras import RealDictCursor, execute_values
from datetime import datetime
from pydantic import ValidationError
import schemas

# --- 1. DATABASE CONNECTIONS ---
def get_source_db():
    """Connects to the legacy/staging SQL database."""
    return psycopg2.connect(
        "dbname=procureos_db user=kushal password=kushal host=100.72.202.71 port=5432"
    )

def get_target_db():
    """Connects to the Agent-First PostgreSQL database."""
    return psycopg2.connect(
        "dbname=procureos_db user=kushal password=kushal host=100.72.202.71 port=5432"
    )

# --- 2. THE NORMALIZATION ENGINE ---
def process_table(source_conn, target_conn, table_name, schema_class, query):
    """
    The core ETL loop for a single table.
    """
    print(f"\n🚀 Processing {table_name}...")
    
    # Extract: Fetch rows as Python dictionaries
    with source_conn.cursor(cursor_factory=RealDictCursor) as cursor:
        cursor.execute(query)
        raw_rows = cursor.fetchall()
    
    valid_records = []
    failed_records = []

    # Transform: Run through Pydantic Gatekeeper
    for row in raw_rows:
        try:
            validated_record = schema_class(**row)
            # Use mode='json' to convert UUIDs and Enums to safe strings
            valid_records.append(validated_record.model_dump(mode='json')) 
        except ValidationError as e:
            failed_records.append({"id": row.get("id"), "error": e.errors()})

    print(f"✅ Clean: {len(valid_records)} | 🚨 Quarantined: {len(failed_records)}")

    # Load: Upsert into PostgreSQL (Implementation depends on library)
    if valid_records:
        upsert_to_postgres(target_conn, table_name, valid_records)
        
    # Log failed records to a file or separate table for review
    if failed_records:
        log_quarantine(table_name, failed_records)


def upsert_to_postgres(conn, table_name, records):
    """
    Generic bulk upsert by primary key column `id`.
    Assumes all records share the same keys and the target table has matching columns.
    """
    if not records:
        return

    columns = list(records[0].keys())
    values = [[record.get(col) for col in columns] for record in records]

    insert_stmt = sql.SQL("INSERT INTO {table} ({fields}) VALUES %s").format(
        table=sql.Identifier(table_name),
        fields=sql.SQL(", ").join(map(sql.Identifier, columns)),
    )
    update_fields = [col for col in columns if col != "id"]
    update_stmt = sql.SQL(", ").join(
        sql.SQL("{col} = EXCLUDED.{col}").format(col=sql.Identifier(col))
        for col in update_fields
    )
    upsert_stmt = insert_stmt + sql.SQL(" ON CONFLICT (id) DO UPDATE SET ") + update_stmt

    with conn.cursor() as cursor:
        execute_values(cursor, upsert_stmt, values)
    conn.commit()


def log_quarantine(table_name, failed_records, output_dir="quarantine"):
    """Append failed records to a per-table JSONL file for review."""
    timestamp = datetime.utcnow().strftime("%Y%m%d")
    file_path = f"{output_dir}/{table_name}_{timestamp}.jsonl"

    try:
        import os

        os.makedirs(output_dir, exist_ok=True)
        with open(file_path, "a", encoding="utf-8") as handle:
            for record in failed_records:
                handle.write(json.dumps(record) + "\n")
    except OSError as exc:
        print(f"⚠️ Failed to write quarantine log: {exc}")

# --- 3. THE ORCHESTRATOR (Order of Operations) ---
if __name__ == "__main__":
    source_db = get_source_db()
    target_db = get_target_db()

    try:
        # TIER 1: No Dependencies
        process_table(
            source_db, target_db,
            table_name="users",
            schema_class=schemas.UserSchema,
            query="SELECT * FROM legacy_users;"
        )
        process_table(
            source_db, target_db,
            table_name="products",
            schema_class=schemas.ProductSchema,
            query="SELECT * FROM legacy_products;"
        )

        # TIER 2: Depends on users/products
        process_table(
            source_db, target_db,
            table_name="orders",
            schema_class=schemas.OrderSchema,
            query="SELECT * FROM legacy_orders;"
        )

        # TIER 3: Depends on orders/products
        process_table(
            source_db, target_db,
            table_name="order_items",
            schema_class=schemas.OrderItemSchema,
            query="SELECT * FROM legacy_order_items;"
        )

    finally:
        source_db.close()
        target_db.close()