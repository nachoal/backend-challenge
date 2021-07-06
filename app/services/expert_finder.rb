class ExpertFinder
  include Executable

  def initialize(starting_member, topic)
    @starting_member = starting_member
    @experts         = Member.talk_about(topic) - starting_member.friends
    @paths           = []
  end


  def execute
    return "No unfriended experts for topic found" if experts.empty?

    experts.each do |goal|
      searched = []
      queue    = [[starting_member]]
  
      return "Member is equal to goal" if starting_member == goal
    
      until queue.empty?
        path = queue.shift
        node = path[-1]
  
        unless searched.include?(node)
          friends = node.friends - searched
  
          friends.each do |friend|
            new_path = path.clone
  
            new_path << friend
            queue    << new_path
            
            if friend == goal
              paths << new_path
            end
          end
  
          searched << node
        end
      end
    end

    return 'No connections found' if paths.empty?
    
    # * Return the shortest path from found possibilites
    # * This result can be customized further to show different expert paths
    format_path(paths.sort_by(&:size).first)
  end

  private

  attr_reader :starting_member, :paths, :experts

  def format_path(connections)
    connections.pluck(:first_name).join("->")
  end
end