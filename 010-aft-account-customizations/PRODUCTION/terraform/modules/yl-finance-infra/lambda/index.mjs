import {
  DynamoDBClient
} from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
  PutCommand,
  GetCommand,
  ScanCommand,
  DeleteCommand
} from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient();
const db = DynamoDBDocumentClient.from(client);
const TABLE_NAME = process.env.TABLE_NAME;

const response = (statusCode, body) => ({
  statusCode,
  headers: {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Headers": "*",
    "Access-Control-Allow-Methods": "OPTIONS,GET,POST,DELETE",
    "Content-Type": "application/json"
  },
  body: JSON.stringify(body),
});

export const handler = async (event) => {
  const method = event.requestContext.http.method;
  const pathParams = event.pathParameters;
  const loanID = pathParams?.proxy || '';
  const body = event.body ? JSON.parse(event.body) : null;

  console.log("Received request:", {
    method,
    path: event.rawPath,
    loanID,
    body,
    TABLE_NAME
  });

  try {
    if (method === "OPTIONS") {
      console.log("Handling CORS preflight");
      return response(200, { message: "CORS preflight OK" });
    }

    if (method === "POST") {
      if (!body || !body.borrowerName || !loanID) {
        console.warn("POST: Missing required fields", { loanID, body });
        return response(400, { message: "Invalid request body or missing loan ID" });
      }

      console.log("POST: Adding loan", { loanID, borrowerName: body.borrowerName });

      await db.send(new PutCommand({
        TableName: TABLE_NAME,
        Item: {
          loanID,
          borrowerName: body.borrowerName
        }
      }));

      console.log("Loan added successfully:", loanID);
      return response(200, { message: "Loan added" });
    }

    if (method === "GET" && loanID === "all") {
      console.log("GET: Fetching all loans");
      const result = await db.send(new ScanCommand({ TableName: TABLE_NAME }));
      console.log("GET: All loans fetched:", result.Items?.length || 0);
      return response(200, result.Items || []);
    }

    if (method === "GET") {
      console.log("GET: Fetching loan by ID:", loanID);
      const result = await db.send(new GetCommand({
        TableName: TABLE_NAME,
        Key: { loanID }
      }));

      if (!result.Item) {
        console.warn("GET: Loan not found:", loanID);
        return response(404, { message: "Loan not found" });
      }

      console.log("GET: Loan found:", result.Item);
      return response(200, result.Item);
    }

    if (method === "DELETE") {
      console.log("DELETE: Removing loan", loanID);

      await db.send(new DeleteCommand({
        TableName: TABLE_NAME,
        Key: { loanID }
      }));

      console.log("Loan deleted:", loanID);
      return response(200, { message: "Loan deleted" });
    }

    console.warn("Unsupported method:", method);
    return response(405, { message: `Unsupported method: ${method}` });

  } catch (err) {
    console.error("Error processing request:", err);
    return response(500, { message: "Internal server error", error: err.message });
  }
};
