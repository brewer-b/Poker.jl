module PokerCard

export Card

struct Card
    value::UInt8
    function Card(value::Integer)
        @assert(value >= 1 && value <= 52)
        return new(UInt8(value))
    end
end

const ranks = "23456789TJQKA"
const suits = "cdhs"

function Card(card::String)
    @assert(length(card) == 2)
    rank = findfirst(card[1], ranks)
    suit = findfirst(card[2], suits)
    @assert(!isnothing(rank) && !isnothing(suit))
    value = ((rank - 1) * 4) + (suit - 1) + 1
    return Card(value)
end

Base.:string(card::Card) = string(ranks[(card.value - 1) ÷ 4 + 1], suits[(card.value - 1) % 4 + 1])
Base.show(io::IO, card::Card) = print(string(card))
Base.show(io::IO, cards::Vector{Card}) = [print(card) for card in cards]
Base.:+(x::Integer, card::Card) = x + UInt64(card.value)
Base.:+(card::Card, x::Integer) = Base.:+(x::Integer, card::Card)

println([Card(3),Card(4)])

end