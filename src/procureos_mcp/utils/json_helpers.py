import json


def to_json(data) -> str:
	return json.dumps(data, indent=2, default=str)
