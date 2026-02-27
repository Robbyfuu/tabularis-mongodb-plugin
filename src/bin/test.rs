/// Minimal sanity-check: connect to a local MongoDB, run a ping.
/// Usage: cargo run --bin test
use mongodb::Client;

#[tokio::main]
async fn main() {
    let uri = std::env::var("MONGODB_URI")
        .unwrap_or_else(|_| "mongodb://localhost:27017".to_string());

    let client = Client::with_uri_str(&uri)
        .await
        .expect("Failed to create MongoDB client");

    let db = client.database("admin");
    db.run_command(bson::doc! { "ping": 1 })
        .await
        .expect("Ping failed");

    println!("Connected to MongoDB at {}", uri);
}
