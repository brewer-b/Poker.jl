module PokerCard

export Card, validCard

const ranks = "23456789TJQKA"
const suits = "cdhs"

primitive type Card <: Integer 8 end

Card(card::Integer) = reinterpret(Card, UInt8(card))
Core.UInt8(card::Card) = reinterpret(UInt8, card)
Core.UInt64(card::Card) = UInt64(UInt8(card))

function Card(card::String)
    @assert(length(card) == 2)
    rank = findfirst(card[1], ranks)
    suit = findfirst(card[2], suits)
    @assert(!isnothing(rank) && !isnothing(suit))
    value = (rank * 4) + suit
    return Card(value)
end

validCard(card::Card) = card >= 0 && card <= 51

Base.:+(x::Integer, card::Card) = x + UInt64(card)
Base.:+(card::Card, x::Integer) = Base.:+(x::Integer, card::Card)
Base.:-(x::Integer, card::Card) = x - UInt64(card)
Base.:-(card::Card, x::Integer) = UInt64(card) - x
Base.:string(card::Card) = string(ranks[UInt64(card) ÷ 4 + 1], suits[UInt64(card) % 4 + 1])
Base.show(io::IO, card::Card) = print(string(card))
Base.show(io::IO, cards::AbstractVector{Card}) = [print(card) for card in cards]

end