# OrganizationApi

# OrganizationApi

## Usage

To run the application, follow these steps:

1. Clone the repository.
2. Install dependencies with `mix deps.get`.
3. Create a `.env.exs` environment file and add your database username and password in the format provided in `sample.env.exs`
4. Run `mix ecto.create` for creating the databases needed and run migration using command `mix ecto.migrate`.
4. Start the Phoenix server with `mix phx.server`.Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

The application should now be running, and you can make requests to the endpoints using tools like Postman or cURL.

## Routes

The following routes are available:
- `GET /api/organizations`: Lists all organizations.
- `POST /api/organizations`: Creates a new organization.
- `GET /api/organizations/:id`: Retrieves a specific organization.
- `PUT /api/organizations/:id`: Updates an existing organization.
- `DELETE /api/organizations/:id`: Deletes an existing organization.

## Testing

You can run the tests with the following command:

```
mix test
```