################################################################################
# This is an example Freeplay player.  It's very dumb, always moving
# to the first open space it can find.
class Dummy < Freeplay::Player

  ##############################################################################
  def move
    x, y = nil, nil

    if board.last_opponent_move
      logger.info("searching for an open adjacent space")

      x, y = find_space_adjacent_to_opponents_last_move(board.last_opponent_move)
    end

    if still_need_a_move?(x, y)
      logger.info("searching for first available space")

      x, y = find_first_available_space
    end

    # Return the desired location on the board.
    [x, y]
  end

  def still_need_a_move?(x, y)
    x.nil? || y.nil?
  end

  def find_space_adjacent_to_opponents_last_move(opponent_last_move)
      allowed = board.adjacent(*opponent_last_move)
      match = allowed.detect {|(ax, ay)| board[ax, ay] == :empty}
      if match
        match
      else
        [nil, nil]
      end
  end

  def find_first_available_space
      catch(:found_empty_space) do
        board.size.times do |bx|
          board.size.times do |by|
            throw(:found_empty_space, [bx, by]) if board[bx, by] == :empty
          end
        end
      end
  end
end
