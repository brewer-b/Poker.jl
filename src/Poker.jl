module Poker

export Card, validCard
export handRanks, evaluate5c, evaluate7c, evaluatePartial
export HandIndexer, size, indexLast, unindex
export handFromIndex, indexFromHand, blockedIndexesFromCard

#Cards are 0 indexed for better interop with the hand isomorphism library
include("Card.jl")
using .PokerCard
include("HandEvaluator.jl")
using .PokerHandEvaluator
include("HandIsomorphism.jl")
using .PokerHandIsomorphism
include("HoldemHand.jl")
using .PokerHoldemHand

end
