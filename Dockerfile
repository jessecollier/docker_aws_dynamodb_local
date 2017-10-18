#
# Dockerfile for DynamoDB Local
#
# https://aws.amazon.com/blogs/aws/dynamodb-local-for-desktop-development/
#
FROM java:8-alpine

ARG BASE_DIR=/dynamodb
ARG DB_PATH=$BASE_DIR/db

# Create working space
WORKDIR $BASE_DIR

# Default port for DynamoDB Local
EXPOSE 8000

# Get the package from Amazon
RUN apk --no-cache add ca-certificates openssl && update-ca-certificates && \
    wget -O /tmp/dynamodb_local_latest https://s3-us-west-2.amazonaws.com/dynamodb-local/dynamodb_local_latest.tar.gz && \
    tar xfz /tmp/dynamodb_local_latest && \
    rm -f /tmp/dynamodb_local_latest

# Default command for image
ENTRYPOINT ["/usr/bin/java", "-Djava.library.path=$BASE_DIR", "-jar", "DynamoDBLocal.jar", "-dbPath", "$DB_PATH" ]
CMD ["-port", "8000"]

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME ["$DB_PATH", "$BASE_DIR"]
