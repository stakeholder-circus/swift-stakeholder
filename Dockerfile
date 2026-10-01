FROM swift:6.4
WORKDIR /app
COPY Package.swift .
COPY Sources ./Sources
COPY Tests ./Tests
RUN swift build
RUN swift test
ENTRYPOINT ["swift", "run", "stakeholder"]
