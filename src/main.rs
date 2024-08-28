use lambda_runtime::{service_fn, LambdaEvent, Error};
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
struct Request {
    message: String,
}

#[derive(Serialize, Deserialize)]
struct Response {
    message: String,
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    let func = service_fn(handler);
    lambda_runtime::run(func).await?;
    Ok(())
}

async fn handler(event: LambdaEvent<Request>) -> Result<Response, Error> {
    let (event, _context) = event.into_parts();
    Ok(Response {
        message: format!("Hello, {}!", event.message),
    })
}
