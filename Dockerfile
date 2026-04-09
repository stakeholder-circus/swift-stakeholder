FROM swift:5.10
WORKDIR /app
COPY Package.swift .
COPY Sources ./Sources
COPY Tests ./Tests
RUN swift build
RUN swift test
ENTRYPOINT ["swift", "run", "stakeholder"]
