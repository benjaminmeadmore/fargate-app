import pytest
import json

# Response format changed to json from plain text
def test_main_page(client):
    response = client.get('/')
    data = json.loads(response.data)
    assert data == {"message": "Hello, World"}
