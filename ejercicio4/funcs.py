import json

@outputSchema("num:long")
def CountProducts(jotason):
	j = json.load(jotason)
	return j['products'].length