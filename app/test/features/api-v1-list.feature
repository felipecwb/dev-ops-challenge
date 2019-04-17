Feature: REST for todo list endpoint

    Scenario: list when empty
        When I request '/v1/list' using HTTP GET
        Then the response code is 200

    Scenario: create a item with description
        Given the 'Content-Type' request header is 'application/json'
        And the request body is:
        """
        {
          "title": "test",
          "description": "optional field"
        }
        """
        When I request '/v1/list' using HTTP POST
        Then the response code is 201
        And the response body contains JSON:
        """
        {
          "id": "@regExp(/[0-9]+/)",
          "title": "test",
          "description": "optional field",
          "status": "pending",
          "created_at": "@variableType(string)",
          "updated_at": "@variableType(string)"
        }
        """

    Scenario: list with one item
        When I request '/v1/list' using HTTP GET
        Then the response code is 200
        And the response body is a JSON array with a length of at least 1

    Scenario: list with pending filter
        When I request '/v1/list?status=pending' using HTTP GET
        Then the response code is 200
        And the response body is a JSON array with a length of at least 1

    Scenario: set item to done
        When I request '/v1/list/1/done' using HTTP POST
        Then the response code is 200
        And the response body contains JSON:
        """
        {
          "id": "@regExp(/[0-9]+/)",
          "title": "@variableType(string)",
          "status": "done",
          "created_at": "@variableType(string)",
          "updated_at": "@variableType(string)"
        }
        """

    Scenario: list with done filter
        When I request '/v1/list?status=done' using HTTP GET
        Then the response code is 200
        And the response body is a JSON array with a length of at least 1

    Scenario: delete an item
        When I request '/v1/list/1' using HTTP DELETE
        Then the response code is 200
        And the response body contains JSON:
        """
        {
          "id": "@regExp(/[0-9]+/)",
          "title": "@variableType(string)",
          "status": "@variableType(string)",
          "created_at": "@variableType(string)",
          "updated_at": "@variableType(string)"
        }
        """
  