describe ExpertFinder do
  let(:starting_member)    { create(:member) }
  let(:connected_friend_a) { create(:member) }
  let(:connected_friend_b) { create(:member) }
  let(:expert)             { create(:member) }
  let(:topic)              { 'RSpec' }
  let!(:expert_heading)    { create(:heading, member: expert, content: topic) }


  describe "#execute" do
    subject(:execute) do
      described_class.execute(starting_member, topic)
    end

    context "with one degree connection" do
      let!(:friendship_a) do
        create(:friendship, member: starting_member, friend: connected_friend_a)
      end
      let!(:friendship_b) do
        create(:friendship, member: connected_friend_a, friend: expert)
      end

      it "returns the shortest path to an expert" do
        is_expected.to eq(
          [
            starting_member,
            connected_friend_a,
            expert
          ].pluck(:first_name).join("->")
        )
      end
    end

    context "with two degrees connection" do
      let!(:friendship_a) do
        create(:friendship, member: starting_member, friend: connected_friend_a)
      end
      let!(:friendship_b) do
        create(
          :friendship,
          member: connected_friend_a,
          friend: connected_friend_b
        )
      end
      let!(:friendship_c) do
        create(:friendship, member: connected_friend_b, friend: expert)
      end

      it "returns the shortest path to an expert" do
        is_expected.to eq(
          [
            starting_member,
            connected_friend_a,
            connected_friend_b,
            expert
          ].pluck(:first_name).join("->")
        )
      end
    end

    context "with no connections" do
      let!(:friendship_a) do
        create(:friendship, member: expert, friend: connected_friend_a)
      end

      it "returns a string" do
        is_expected.to eq("No connections found")
      end
    end

    context "with starting_member being the expert" do
      let!(:expert_heading) do
        create(:heading, member: starting_member, content: topic)
      end

      it "returns a string" do
        is_expected.to eq("Member is equal to goal")
      end
    end

    context "with starting_member already friends with expert" do
      let!(:friendship_a) do
        create(:friendship, member: starting_member, friend:expert)
      end

      it "returns a string" do
        is_expected.to eq("No unfriended experts for topic found")
      end
    end

  end
end
