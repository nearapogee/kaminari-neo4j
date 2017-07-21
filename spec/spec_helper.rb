require 'rails'
require 'kaminari-neo4j'
require 'neo4j/core/cypher_session/adaptors/http'

port = ENV['NEO4J_PORT'] || 7475
adaptor = Neo4j::Core::CypherSession::Adaptors::HTTP.
  new("http://localhost:#{port}")
Neo4j::ActiveBase.on_establish_session {
  Neo4j::Core::CypherSession.new(adaptor)
}

RSpec.configure do |config|
  config.before(:all) do
    Neo4j::ActiveBase.current_session.query <<-CYPHER
      CREATE CONSTRAINT ON (n:MyThing) ASSERT n.uuid IS UNIQUE;
    CYPHER
  end
  config.before(:each) do
    Neo4j::ActiveBase.current_session.query <<-CYPHER
      MATCH (n) DETACH DELETE n;
    CYPHER
  end

  config.after(:all) do
    Neo4j::ActiveBase.current_session.query <<-CYPHER
      DROP CONSTRAINT ON (n:MyThing) ASSERT n.uuid IS UNIQUE;
    CYPHER
  end
end
