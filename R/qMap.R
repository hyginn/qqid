# qMap.R

#' qMap
#'
#' \code{qMap} maps numbers to Q-words, or Q-words to their index in the Q-word
#' vector.
#'
#' @section Description: \code{qMap} accepts strings that are matched to Q-word
#'   indices or NA, or numbers that are matched to Q-words or NA. The returned
#'   vector has the same length as the input. Numbers that are not in (1, 1024)
#'   return NA. Strings that are not a Q-word return NA.
#'
#' @section Q-Words: A table of 1,024 four-letter words is encoded in this
#'   function. Four-letter English words were chosen and manually refined to
#'   yield short, unique labels that: \itemize{ \item are monosyllabic, \item
#'   are easy to spell and pronounce, \item are individually not offensive,
#'   \item are unlikely to be offensive in random combination, \item are in
#'   common use, \item avoid homophones and consonant clusters, \item do not
#'   contain jargon, intentional misspellings, acronyms or overly specialized
#'   technical or sports terms. }
#'
#' @param x (character or numeric) A vector.
#' @return (numeric or character) A vector of Indices, Q-words, or NA of the
#'   same length as the input.
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @examples
#' # qMap a number
#' qMap(314)   # "gift"
#' # qMap four words, three can be matched.
#' qMap(c("three", "free", "cold", "beer"))  # NA 288  126  35
#' # return the entire QQ table
#' x <- qMap(1:1024)
#'
#' @export

qMap <- function(x) {

  Q <- c("aims", "ants", "arch", "arms", "arts", "aunt", "back", "bail", # 0001
         "bake", "bald", "ball", "balm", "band", "bane", "bank", "bans", # 0009
         "barb", "bare", "bark", "barn", "bars", "base", "bath", "bats", # 0017
         "bays", "bead", "beak", "beam", "bean", "bear", "beat", "beds", # 0025
         "beef", "been", "beer", "bees", "beet", "bell", "belt", "bend", # 0033
         "bent", "best", "bets", "bids", "bike", "bile", "bill", "bind", # 0041
         "bins", "bird", "bite", "bits", "blot", "blue", "blur", "boar", # 0049
         "boat", "boil", "bold", "bolt", "bond", "bone", "book", "boot", # 0057
         "bore", "born", "both", "bout", "bowl", "bows", "boys", "brag", # 0065
         "bred", "brew", "brow", "buds", "bugs", "bulb", "bulk", "bull", # 0073
         "bump", "burn", "burr", "cage", "cake", "calf", "call", "calm", # 0081
         "came", "camp", "cane", "cans", "cape", "caps", "card", "care", # 0089
         "carp", "cars", "cart", "case", "cash", "cast", "cats", "cave", # 0097
         "cell", "chat", "chef", "chew", "chin", "chip", "chop", "cite", # 0105
         "clad", "clan", "claw", "clay", "clip", "clog", "club", "clue", # 0113
         "coal", "coat", "code", "coil", "coin", "cold", "comb", "cone", # 0121
         "cook", "cool", "coop", "cope", "cord", "core", "cork", "corn", # 0129
         "cost", "coup", "cove", "cows", "crab", "crew", "crib", "crop", # 0137
         "crow", "cube", "cubs", "cues", "cuff", "cult", "cups", "curb", # 0145
         "cure", "curl", "cute", "dame", "damp", "dams", "dare", "dark", # 0153
         "dart", "dash", "date", "dawn", "days", "dead", "deaf", "deal", # 0161
         "dean", "debt", "deck", "deed", "deem", "deep", "deer", "dent", # 0169
         "desk", "died", "dies", "dine", "dirt", "dish", "disk", "dive", # 0177
         "dock", "docs", "does", "dogs", "doll", "dome", "done", "doom", # 0185
         "door", "dose", "dots", "dove", "down", "drag", "draw", "drip", # 0193
         "drop", "drug", "drum", "duck", "dues", "duke", "dull", "dump", # 0201
         "dune", "dusk", "dust", "each", "earn", "ears", "ease", "east", # 0209
         "eats", "edge", "eels", "eggs", "elks", "else", "ends", "face", # 0217
         "fact", "fade", "fail", "fair", "fake", "fall", "fame", "fang", # 0225
         "fans", "fare", "farm", "fast", "fate", "fawn", "fear", "feat", # 0233
         "feel", "fees", "feet", "fell", "felt", "fern", "feud", "figs", # 0241
         "file", "fill", "film", "find", "fine", "fins", "firm", "fish", # 0249
         "fist", "fits", "five", "flag", "flat", "flaw", "flax", "flea", # 0257
         "fled", "flew", "flex", "flip", "flop", "flow", "flux", "foal", # 0265
         "foam", "foil", "fold", "folk", "fond", "font", "food", "fool", # 0273
         "foot", "fork", "form", "fort", "foul", "four", "fowl", "free", # 0281
         "frog", "from", "fuel", "full", "fume", "fund", "fuse", "fuss", # 0289
         "gaff", "gage", "gain", "gait", "gale", "gall", "game", "gang", # 0297
         "gaps", "gash", "gate", "gave", "gaze", "gear", "gems", "gene", # 0305
         "germ", "gift", "gill", "girl", "give", "glad", "glow", "glue", # 0313
         "glum", "goal", "goat", "goes", "gold", "golf", "gone", "gong", # 0321
         "good", "gown", "grab", "gram", "gray", "grew", "grid", "grim", # 0329
         "grin", "grip", "grog", "grow", "grub", "gulf", "gull", "gust", # 0337
         "guts", "guys", "hack", "hail", "hair", "half", "hall", "halt", # 0345
         "hand", "hang", "hard", "hare", "harm", "harp", "hats", "haul", # 0353
         "have", "hawk", "haze", "head", "heal", "heap", "hear", "heat", # 0361
         "heed", "heel", "heir", "held", "helm", "help", "hemp", "hens", # 0369
         "herb", "herd", "here", "hide", "high", "hike", "hill", "hint", # 0377
         "hiss", "hits", "hive", "hoax", "hold", "home", "hone", "hood", # 0385
         "hoof", "hook", "hoop", "hope", "horn", "hose", "host", "howl", # 0393
         "huge", "hugs", "hull", "hums", "hunt", "hurt", "hush", "husk", # 0401
         "huts", "inns", "isle", "jade", "jail", "jams", "jars", "jaws", # 0409
         "jest", "jets", "jobs", "join", "joke", "jolt", "joys", "jump", # 0417
         "june", "junk", "just", "keel", "keen", "keep", "kegs", "kept", # 0425
         "keys", "kick", "kids", "kiln", "kind", "king", "kiss", "kite", # 0433
         "kits", "knee", "knew", "knit", "knot", "know", "labs", "lace", # 0441
         "lack", "laid", "lake", "lamb", "lame", "lamp", "land", "lane", # 0449
         "laps", "lark", "last", "late", "laud", "lawn", "laws", "lead", # 0457
         "leaf", "leak", "lean", "leap", "leek", "left", "legs", "lend", # 0465
         "lens", "lent", "less", "lids", "lied", "lies", "life", "lift", # 0473
         "like", "limb", "lime", "limp", "line", "link", "lint", "lips", # 0481
         "lisp", "list", "live", "load", "loaf", "loan", "lock", "lode", # 0489
         "loft", "logs", "lone", "long", "look", "loom", "loop", "lord", # 0497
         "lore", "lose", "loss", "lost", "lots", "loud", "love", "luck", # 0505
         "lull", "lump", "lung", "lure", "lurk", "lush", "lute", "lynx", # 0513
         "made", "mail", "main", "make", "male", "mall", "malt", "mane", # 0521
         "maps", "mare", "mark", "mash", "mask", "mast", "mate", "math", # 0529
         "maze", "mead", "meal", "mean", "meet", "melt", "mens", "mere", # 0537
         "mesh", "mess", "mice", "mild", "mile", "milk", "mill", "mime", # 0545
         "mind", "mine", "mink", "mint", "miss", "mist", "mite", "moat", # 0553
         "mock", "mode", "mold", "mole", "monk", "mood", "moon", "more", # 0561
         "moss", "most", "moth", "move", "much", "mugs", "mule", "muse", # 0569
         "must", "mute", "myth", "nail", "name", "nape", "near", "neat", # 0577
         "neck", "need", "nest", "nets", "news", "newt", "nice", "nick", # 0585
         "nine", "node", "none", "noon", "norm", "nose", "note", "noun", # 0593
         "oaks", "oath", "odds", "oils", "once", "ones", "owls", "owns", # 0601
         "pace", "pack", "page", "paid", "pail", "pair", "pale", "palm", # 0609
         "pane", "pant", "park", "part", "past", "path", "pave", "pawn", # 0617
         "paws", "pays", "peak", "pear", "peas", "peat", "peck", "peel", # 0625
         "peer", "pens", "perk", "pest", "pets", "pick", "pies", "pike", # 0633
         "pile", "pill", "pine", "pins", "pint", "pipe", "pits", "plan", # 0641
         "play", "plea", "plot", "plow", "ploy", "plum", "plus", "pods", # 0649
         "pole", "poll", "pond", "pool", "poor", "pope", "pork", "port", # 0657
         "pose", "post", "pots", "pour", "prep", "prey", "prod", "prop", # 0665
         "prow", "puff", "pull", "pulp", "pump", "pure", "push", "quit", # 0673
         "quiz", "raft", "rage", "rags", "raid", "rail", "rain", "rake", # 0681
         "ramp", "rang", "rank", "rant", "rare", "rash", "rate", "rats", # 0689
         "rave", "rays", "read", "real", "reap", "rear", "reed", "reef", # 0697
         "reel", "rent", "rest", "ribs", "rice", "rich", "ride", "rift", # 0705
         "ring", "rink", "ripe", "rise", "risk", "road", "roar", "robe", # 0713
         "rock", "rode", "rods", "roll", "roof", "rook", "room", "root", # 0721
         "rope", "rose", "rugs", "rule", "rump", "rung", "runs", "runt", # 0729
         "rush", "rust", "safe", "sage", "said", "sail", "salt", "same", # 0737
         "sand", "sane", "sang", "sash", "save", "saws", "says", "scam", # 0745
         "scan", "scar", "seal", "seam", "seas", "seat", "sect", "seed", # 0753
         "seek", "seem", "seen", "sees", "self", "sell", "sent", "sets", # 0761
         "shed", "shim", "shin", "ship", "shoe", "shop", "shot", "show", # 0769
         "shut", "side", "sift", "sigh", "sign", "silk", "sill", "sing", # 0777
         "sink", "sins", "site", "sits", "size", "skew", "skid", "skin", # 0785
         "skip", "slab", "slap", "slat", "sled", "slid", "slim", "slip", # 0793
         "slot", "slow", "slug", "smug", "snag", "snap", "snip", "snow", # 0801
         "soak", "soap", "soar", "sock", "soft", "soil", "sold", "sole", # 0809
         "some", "song", "sons", "soon", "soot", "sore", "sort", "soul", # 0817
         "soup", "spam", "span", "spar", "spin", "spot", "spun", "spur", # 0825
         "stab", "stag", "star", "stay", "stem", "step", "stew", "stir", # 0833
         "stop", "stow", "stub", "such", "suit", "sump", "sums", "sung", # 0841
         "sunk", "suns", "sure", "surf", "swam", "swan", "swap", "swat", # 0849
         "sway", "swim", "tabs", "tack", "tags", "tail", "take", "talk", # 0857
         "tall", "tang", "tank", "tape", "taps", "task", "teak", "teal", # 0865
         "team", "tear", "teas", "teem", "tell", "temp", "tend", "tent", # 0873
         "term", "tern", "test", "than", "that", "thaw", "thee", "them", # 0881
         "then", "they", "thin", "this", "thus", "tick", "tide", "tier", # 0889
         "ties", "tile", "till", "tilt", "time", "tine", "tint", "tips", # 0897
         "toad", "toes", "toil", "told", "toll", "tomb", "tone", "tong", # 0905
         "took", "tool", "tops", "torn", "tort", "toss", "tour", "town", # 0913
         "toys", "tram", "trap", "tray", "tree", "trim", "trip", "trod", # 0921
         "true", "tube", "tubs", "tuck", "tune", "turf", "turn", "twig", # 0929
         "twin", "type", "urge", "vain", "vase", "vast", "veer", "veil", # 0937
         "vent", "verb", "vest", "view", "vine", "vise", "void", "vole", # 0945
         "volt", "vote", "vows", "wade", "wage", "wail", "wait", "wake", # 0953
         "walk", "wall", "wand", "want", "ward", "ware", "warm", "warn", # 0961
         "warp", "wars", "wash", "wasp", "watt", "wave", "weak", "wear", # 0969
         "webs", "week", "weep", "weld", "well", "went", "were", "west", # 0977
         "what", "when", "whim", "whip", "whom", "wick", "wide", "wife", # 0985
         "wigs", "wild", "will", "wind", "wine", "wing", "wink", "wins", # 0993
         "wipe", "wise", "wish", "with", "wolf", "wood", "wool", "word", # 1001
         "wore", "work", "worm", "worn", "wove", "wrap", "wren", "yard", # 1009
         "yarn", "yawn", "year", "yell", "your", "zest", "zinc", "zone") # 1017

  if (is.numeric(x) && is.vector(x)) {
    v <- Q[match(x, 1:1024)]
  } else if (is.character(x) && is.vector(x)) {
    v <- match(x, Q)
  } else {
    stop("input must be a numeric or character vector.")
  }

  return(v)
}

# [END]
