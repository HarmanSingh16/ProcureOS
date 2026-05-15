from schemas import UserSchema
from mock_db import mock_sql_users
from pydantic import ValidationError

valid_users = []
failed_users = []

for raw_row in mock_sql_users:
    try:
        # Attempt to validate the row
        validated_record = UserSchema(**raw_row)
        
        # If it passes, append the clean data (using .model_dump() to turn it back to a dict)
        valid_users.append(validated_record.model_dump())
        
    except ValidationError as e:
        # If it fails, quarantine the raw row and the error message
        failed_users.append({
            "bad_data": raw_row,
            "error_details": e.errors()
        })

print(f"Successfully validated: {len(valid_users)} users")
print(f"Quarantined: {len(failed_users)} users")