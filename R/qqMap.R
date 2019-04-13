# qqMap.R

#' qqMap
#'
#' \code{<function>} maps numbers to QQ words, or words to their index
#'                   in the QQ table.
#'
#' Details.
#' @section Description: Map words to their index in the QQ table, or indices
#'                       to the corresponding  word. If x is of type character,
#'                       the corresponding indices are returned. If x is of
#'                       type numeric, the corresponding words are returned.
#'                       The returned vector has the same length as x. Numbers
#'                       that are not in [1, 2, ... 1024] are mapped to NA.
#'                       Strings that are not a QQword are mapped to NA.
#'
#'                       More details on the QQ words.
#'
#' @param x (character or numeric) A vector.
#' @return (numeric or character) Indices or QQwords.
#'
#' @author \href{https://orcid.org/0000-0002-1134-6758}{Boris Steipe} (aut)
#'
#' @examples
#' # qqMap a number
#' qqMap(664)   # "joke"
#' # qqMap three words
#' qqMap(c("three", "free", "cold", "beer"))  # NA 478  23 261
#' # return the entire QQ table
#' x <- qqMap(1:1024)
#'
#' @export

qqMap <- function(x) {

  w1024 <- c("love", "maps", "ease", "fist", "wasp", "rice", "work", "stag",
             "hush", "here", "wing", "grip", "dams", "seen", "eats", "pork",
             "date", "sunk", "heal", "mesh", "bump", "lurk", "cold", "ride",
             "ruin", "jets", "claw", "slug", "legs", "bans", "boar", "sums",
             "flaw", "wash", "cite", "cake", "ramp", "loud", "puff", "maze",
             "bond", "font", "loan", "toad", "pole", "soft", "skip", "knee",
             "zinc", "hiss", "wind", "bars", "soil", "bear", "rope", "flat",
             "lack", "club", "snow", "guts", "fame", "pain", "hill", "fork",
             "drop", "some", "drip", "thus", "limb", "cars", "flop", "malt",
             "suit", "herd", "till", "rank", "leak", "name", "post", "mail",
             "pick", "kept", "smug", "node", "swap", "dash", "tubs", "chip",
             "wish", "them", "crew", "soup", "mock", "root", "door", "vast",
             "weld", "goat", "lame", "pint", "woes", "tank", "core", "dish",
             "trim", "bent", "note", "move", "reed", "food", "herb", "spun",
             "melt", "brew", "coup", "nine", "joys", "show", "logs", "reap",
             "farm", "bulk", "tine", "snap", "mark", "hose", "horn", "bare",
             "salt", "pane", "time", "bark", "hurt", "reef", "clip", "cool",
             "dome", "lots", "that", "pair", "golf", "wipe", "fell", "hint",
             "arts", "tied", "ship", "home", "flow", "jobs", "flux", "term",
             "torn", "stub", "nets", "fish", "main", "spur", "poll", "leek",
             "shim", "pail", "paid", "feel", "fins", "dark", "task", "pale",
             "tool", "bowl", "fare", "vine", "rule", "lint", "raid", "pope",
             "fast", "cubs", "docs", "lynx", "rush", "pays", "clad", "sale",
             "pure", "wait", "ring", "wolf", "mule", "mole", "flag", "odds",
             "bold", "tops", "duct", "pour", "gust", "loaf", "lisp", "wage",
             "bath", "case", "hens", "rose", "neat", "self", "chew", "face",
             "crab", "flew", "warp", "rain", "cash", "pods", "cage", "else",
             "bays", "star", "bead", "boot", "slap", "file", "told", "sung",
             "saws", "fold", "haul", "bits", "haze", "tube", "fort", "fuse",
             "view", "hoax", "prey", "tell", "fall", "dame", "aunt", "kiln",
             "deaf", "whip", "flex", "mood", "just", "cell", "glue", "turf",
             "palm", "gone", "path", "pave", "arch", "says", "talk", "tail",
             "wars", "burr", "whey", "wife", "beer", "leap", "hunt", "fled",
             "high", "mold", "word", "pike", "dare", "gale", "sins", "grow",
             "mine", "sing", "grew", "heat", "hear", "wave", "laid", "flip",
             "fume", "fuss", "bird", "dent", "wrap", "glad", "pots", "mint",
             "rare", "hull", "hand", "site", "foot", "hard", "pill", "beef",
             "hymn", "doom", "fail", "plus", "pack", "dues", "more", "film",
             "dock", "shoe", "whom", "code", "mode", "noon", "your", "snip",
             "heel", "carp", "crow", "most", "text", "soul", "swim", "ball",
             "hair", "does", "norm", "plow", "mane", "shot", "fuel", "rats",
             "less", "dean", "sort", "pool", "gift", "quit", "skid", "bids",
             "help", "rift", "felt", "worm", "gate", "last", "rate", "sign",
             "made", "real", "stir", "game", "lace", "slim", "silk", "head",
             "tier", "vase", "hack", "robe", "june", "mild", "thee", "whim",
             "glow", "flee", "duck", "lens", "lift", "dorm", "caps", "want",
             "type", "oath", "sold", "cues", "cape", "oils", "kits", "trip",
             "stem", "with", "moth", "warm", "folk", "mime", "coal", "peat",
             "byte", "isle", "mess", "deed", "dull", "grub", "hour", "bone",
             "hits", "long", "nick", "cows", "cove", "gold", "flax", "pens",
             "walk", "ones", "leaf", "laud", "grog", "junk", "rise", "once",
             "card", "tear", "sigh", "coin", "were", "wide", "quiz", "tray",
             "bank", "sled", "dies", "harm", "blur", "sole", "land", "wear",
             "jaws", "plum", "thru", "lose", "rash", "bend", "what", "lead",
             "zoom", "reel", "used", "dawn", "meal", "teas", "this", "chef",
             "spam", "trap", "tack", "hall", "thaw", "sell", "wool", "bean",
             "owns", "peer", "lore", "tent", "need", "pith", "gram", "spot",
             "plan", "rays", "jars", "heir", "song", "took", "tide", "wigs",
             "loss", "lung", "gown", "clay", "heed", "lips", "dive", "toys",
             "read", "knit", "thin", "coop", "bolt", "free", "play", "rake",
             "side", "toll", "wine", "hope", "cork", "lamb", "sure", "lure",
             "pulp", "pits", "asks", "host", "muse", "bike", "hail", "five",
             "pray", "pull", "slid", "chow", "void", "pies", "knew", "grim",
             "ears", "mens", "moat", "huts", "dead", "bile", "hawk", "load",
             "give", "cave", "goes", "soak", "coat", "gull", "mist", "chop",
             "burn", "hold", "slip", "sand", "rant", "seem", "dump", "keen",
             "look", "tick", "tang", "urge", "brag", "king", "fool", "step",
             "part", "drug", "they", "sits", "vain", "sane", "shin", "warn",
             "nose", "germ", "peas", "fine", "bows", "sway", "fees", "cart",
             "tend", "shut", "roll", "grid", "like", "vise", "band", "grab",
             "gong", "form", "barb", "ties", "tern", "pond", "will", "sore",
             "foal", "boys", "lies", "tile", "book", "well", "grin", "hike",
             "sock", "risk", "seed", "true", "lord", "moon", "curb", "peel",
             "plot", "hats", "line", "fear", "done", "tape", "have", "foam",
             "shed", "edge", "toil", "span", "swan", "cult", "said", "tall",
             "loop", "wall", "rode", "mute", "acts", "girl", "bill", "find",
             "then", "room", "pins", "verb", "mice", "veil", "know", "yarn",
             "tort", "foul", "mile", "been", "send", "cats", "curl", "lull",
             "cube", "must", "neck", "lend", "halt", "cook", "beds", "fond",
             "brow", "came", "dear", "fake", "surf", "ploy", "kiss", "maid",
             "tuck", "both", "zone", "huge", "calf", "belt", "inns", "camp",
             "dart", "barn", "harp", "week", "poor", "lied", "swat", "twin",
             "lawn", "sons", "cast", "from", "stew", "arms", "team", "joke",
             "stay", "boat", "lone", "same", "feat", "newt", "slot", "seas",
             "bets", "cord", "page", "next", "pose", "soot", "kite", "laws",
             "damp", "buds", "laps", "cans", "roar", "dirt", "dust", "live",
             "guys", "feet", "jail", "tips", "hugs", "bugs", "east", "sail",
             "lump", "ware", "prod", "rear", "slow", "deal", "gait", "aims",
             "jade", "math", "mink", "weak", "lock", "loft", "gain", "miss",
             "full", "bail", "each", "volt", "rugs", "watt", "much", "alps",
             "limp", "fair", "desk", "husk", "dogs", "sent", "rock", "jams",
             "yawn", "dusk", "rows", "gall", "seal", "toes", "slab", "cost",
             "road", "take", "blue", "bins", "ends", "wren", "news", "mean",
             "gang", "lush", "wore", "scan", "fans", "gill", "mash", "gray",
             "beam", "webs", "goal", "dune", "moss", "dose", "eggs", "tram",
             "tint", "list", "heap", "died", "gems", "beak", "lent", "test",
             "toss", "tune", "tilt", "gulf", "bred", "mare", "fade", "none",
             "wand", "nice", "foil", "back", "bees", "fill", "bald", "taps",
             "mite", "peak", "wake", "bull", "loom", "thug", "dine", "monk",
             "drag", "deem", "bard", "lost", "pier", "ripe", "keep", "bite",
             "hare", "mind", "quay", "cone", "prop", "cute", "doll", "sage",
             "sift", "boss", "male", "debt", "turn", "late", "drum", "cope",
             "kind", "gear", "fits", "sets", "lids", "base", "hood", "bats",
             "shop", "teak", "rest", "gave", "skin", "wail", "myth", "such",
             "sees", "cups", "milk", "oaks", "peek", "pawn", "raft", "hide",
             "ribs", "days", "wade", "pets", "clan", "helm", "near", "bell",
             "tomb", "care", "calm", "pace", "rich", "rang", "tone", "fund",
             "firm", "cane", "tabs", "clue", "cure", "mugs", "suns", "chin",
             "tons", "make", "lake", "ward", "lime", "port", "balm", "went",
             "lark", "crib", "wild", "scar", "link", "pear", "coil", "rail",
             "mall", "keys", "feed", "gage", "spar", "rink", "lean", "tale",
             "wins", "mead", "tags", "frog", "good", "vent", "pipe", "life",
             "left", "hoop", "mask", "seek", "meet", "year", "twig", "pine",
             "rust", "kick", "prep", "boil", "dots", "runs", "deep", "paws",
             "vote", "peck", "wood", "half", "mere", "hang", "gene", "sink",
             "bulb", "feud", "held", "pest", "yell", "mill", "vest", "labs",
             "seam", "bore", "sang", "disk", "fern", "born", "draw", "pile",
             "fact", "lute", "safe", "stab", "when", "fawn", "hemp", "rage",
             "rave", "bind", "past", "wise", "luck", "lamp", "mate", "fate",
             "cuff", "deer", "tree", "town", "yard", "park", "corn", "comb",
             "join", "than", "four", "best", "soon", "seat", "bake", "soar",
             "tong", "nest", "size", "push", "owls", "blot", "temp", "pant",
             "gaze", "keel", "jest", "crop", "down", "noun", "vows", "hook",
             "hash", "west", "dove", "nail", "chat", "soap", "lane", "teal",
             "plea", "tour", "knot", "wink", "howl", "flea", "mast", "stop",
             "spin", "kids", "jump", "duke", "bout", "gaps", "beat", "fang",
             "role", "ants", "worn", "rods", "deck", "scam", "sect", "call",
             "rent", "earn", "roof", "figs", "save", "hive", "rook", "pump")

  if (is.numeric(x) && is.vector(x)) {
    v <- w1024[match(x, 1:1024)]
  } else if (is.character(x) && is.vector(x)) {
    v <- match(x, w1024)
  } else {
    stop("input must be a numeric or character vector.")
  }

  return(v)
}

# [END]
