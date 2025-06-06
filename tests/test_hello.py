import pytest
import json

def test_main_page(client):
    response = client.get('/')
    data = json.loads(response.data)
    assert data == {"message": "Hello, World"}
