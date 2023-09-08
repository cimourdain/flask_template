from tests.factories.user import UserConstructor


def test_endpoint_response(client):
    # GIVEN a user
    UserConstructor(name="other_user3")

    # WHEN I call the client
    response = client.get("/user/")

    # THEN the response states that one user exists in DB
    assert response.json == [
        "other_user3",
    ]
