module PokerHoldemHand

export Hand

using ..PokerCard

function getAllHands()
    allHands = Matrix{Card}(undef, 2, 1326)
    handToIndexTable::Matrix{Int} = zeros(52, 52)
    cardToBlockedHandsTable = [[] for i in 1:52]
    counter = 0
    for i in 0:51
        for j in 0:i-1
            counter += 1
            allHands[1, counter] = Card(i)
            allHands[2, counter] = Card(j)
            handToIndexTable[i+1, j+1] = counter
            handToIndexTable[j+1,i+1] = counter
            push!(cardToBlockedHandsTable[i+1], counter)
            push!(cardToBlockedHandsTable[j+1], counter)
        end
    end
    return allHands, handToIndexTable, cardToBlockedHandsTable
end

const allHands, handToIndexTable, cardToBlockedHandsTable = getAllHands()

handFromIndex(index) = @view allHands[:,index]
indexFromHand(hand::AbstractVector{Card}) = handToIndexTable[hand[1] + 1, hand[2] + 1]
blockedHandsFromCard(card::Card) = cardToBlockedHandsTable[card + 1]

end