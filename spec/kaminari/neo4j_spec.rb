RSpec.describe Kaminari::Neo4j do
  class MyThing
    include Neo4j::ActiveNode
    property :a
    property :x
    id_property :uuid
  end

  let(:total_count){ 10 }
  let(:current_page){ 2 }
  let(:per_page){ 3 }

  subject { MyThing.page(current_page).per(per_page) }

  before do
    total_count.times { MyThing.create!(a: "foo", x: "bar") }
  end

  describe "#current_page" do
    it "returns the current page number" do
      expect(subject.current_page).to eq current_page
    end
  end

  describe "#total_pages" do
    it "returns the total number of pages given the per page size" do
      expect(subject.total_pages).to eq 4 # 10 items ÷ 3 per page = 3 + 1 remainder
    end
  end

  describe "#size" do
    it "returns the number of items per page" do
      expect(subject.size).to eq per_page
    end
  end

  describe "#total" do
    it "returns the total number of items" do
      expect(subject.total).to eq total_count
    end
  end
end
