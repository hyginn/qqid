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
#' qqMap(314)   # "gift"
#' # qqMap three words
#' qqMap(c("three", "free", "cold", "beer"))  # NA 288  126  35
#' # return the entire QQ table
#' x <- qqMap(1:1024)
#'
#' @export

qqMap <- function(x) {

  w1024 <- c("aims", "ants", "arch", "arms", "arts", "aunt", "back", "bail",
             "bake", "bald", "ball", "balm", "band", "bane", "bank", "bans",
             "barb", "bare", "bark", "barn", "bars", "base", "bath", "bats",
             "bays", "bead", "beak", "beam", "bean", "bear", "beat", "beds",
             "beef", "been", "beer", "bees", "beet", "bell", "belt", "bend",
             "bent", "best", "bets", "bids", "bike", "bile", "bill", "bind",
             "bins", "bird", "bite", "bits", "blot", "blue", "blur", "boar",
             "boat", "boil", "bold", "bolt", "bond", "bone", "book", "boot",
             "bore", "born", "both", "bout", "bowl", "bows", "boys", "brag",
             "bred", "brew", "brow", "buds", "bugs", "bulb", "bulk", "bull",
             "bump", "burn", "burr", "cage", "cake", "calf", "call", "calm",
             "came", "camp", "cane", "cans", "cape", "caps", "card", "care",
             "carp", "cars", "cart", "case", "cash", "cast", "cats", "cave",
             "cell", "chat", "chef", "chew", "chin", "chip", "chop", "cite",
             "clad", "clan", "claw", "clay", "clip", "clog", "club", "clue",
             "coal", "coat", "code", "coil", "coin", "cold", "comb", "cone",
             "cook", "cool", "coop", "cope", "cord", "core", "cork", "corn",
             "cost", "coup", "cove", "cows", "crab", "crew", "crib", "crop",
             "crow", "cube", "cubs", "cues", "cuff", "cult", "cups", "curb",
             "cure", "curl", "cute", "dame", "damp", "dams", "dare", "dark",
             "dart", "dash", "date", "dawn", "days", "dead", "deaf", "deal",
             "dean", "debt", "deck", "deed", "deem", "deep", "deer", "dent",
             "desk", "died", "dies", "dine", "dirt", "dish", "disk", "dive",
             "dock", "docs", "does", "dogs", "doll", "dome", "done", "doom",
             "door", "dose", "dots", "dove", "down", "drag", "draw", "drip",
             "drop", "drug", "drum", "duck", "dues", "duke", "dull", "dump",
             "dune", "dusk", "dust", "each", "earn", "ears", "ease", "east",
             "eats", "edge", "eels", "eggs", "elks", "else", "ends", "face",
             "fact", "fade", "fail", "fair", "fake", "fall", "fame", "fang",
             "fans", "fare", "farm", "fast", "fate", "fawn", "fear", "feat",
             "feel", "fees", "feet", "fell", "felt", "fern", "feud", "figs",
             "file", "fill", "film", "find", "fine", "fins", "firm", "fish",
             "fist", "fits", "five", "flag", "flat", "flaw", "flax", "flea",
             "fled", "flew", "flex", "flip", "flop", "flow", "flux", "foal",
             "foam", "foil", "fold", "folk", "fond", "font", "food", "fool",
             "foot", "fork", "form", "fort", "foul", "four", "fowl", "free",
             "frog", "from", "fuel", "full", "fume", "fund", "fuse", "fuss",
             "gaff", "gage", "gain", "gait", "gale", "gall", "game", "gang",
             "gaps", "gash", "gate", "gave", "gaze", "gear", "gems", "gene",
             "germ", "gift", "gill", "girl", "give", "glad", "glow", "glue",
             "glum", "goal", "goat", "goes", "gold", "golf", "gone", "gong",
             "good", "gown", "grab", "gram", "gray", "grew", "grid", "grim",
             "grin", "grip", "grog", "grow", "grub", "gulf", "gull", "gust",
             "guts", "guys", "hack", "hail", "hair", "half", "hall", "halt",
             "hand", "hang", "hard", "hare", "harm", "harp", "hats", "haul",
             "have", "hawk", "haze", "head", "heal", "heap", "hear", "heat",
             "heed", "heel", "heir", "held", "helm", "help", "hemp", "hens",
             "herb", "herd", "here", "hide", "high", "hike", "hill", "hint",
             "hiss", "hits", "hive", "hoax", "hold", "home", "hone", "hood",
             "hoof", "hook", "hoop", "hope", "horn", "hose", "host", "howl",
             "huge", "hugs", "hull", "hums", "hunt", "hurt", "hush", "husk",
             "huts", "inns", "isle", "jade", "jail", "jams", "jars", "jaws",
             "jest", "jets", "jobs", "join", "joke", "jolt", "joys", "jump",
             "june", "junk", "just", "keel", "keen", "keep", "kegs", "kept",
             "keys", "kick", "kids", "kiln", "kind", "king", "kiss", "kite",
             "kits", "knee", "knew", "knit", "knot", "know", "labs", "lace",
             "lack", "laid", "lake", "lamb", "lame", "lamp", "land", "lane",
             "laps", "lark", "last", "late", "laud", "lawn", "laws", "lead",
             "leaf", "leak", "lean", "leap", "leek", "left", "legs", "lend",
             "lens", "lent", "less", "lids", "lied", "lies", "life", "lift",
             "like", "limb", "lime", "limp", "line", "link", "lint", "lips",
             "lisp", "list", "live", "load", "loaf", "loan", "lock", "lode",
             "loft", "logs", "lone", "long", "look", "loom", "loop", "lord",
             "lore", "lose", "loss", "lost", "lots", "loud", "love", "luck",
             "lull", "lump", "lung", "lure", "lurk", "lush", "lute", "lynx",
             "made", "mail", "main", "make", "male", "mall", "malt", "mane",
             "maps", "mare", "mark", "mash", "mask", "mast", "mate", "math",
             "maze", "mead", "meal", "mean", "meet", "melt", "mens", "mere",
             "mesh", "mess", "mice", "mild", "mile", "milk", "mill", "mime",
             "mind", "mine", "mink", "mint", "miss", "mist", "mite", "moat",
             "mock", "mode", "mold", "mole", "monk", "mood", "moon", "more",
             "moss", "most", "moth", "move", "much", "mugs", "mule", "muse",
             "must", "mute", "myth", "nail", "name", "nape", "near", "neat",
             "neck", "need", "nest", "nets", "news", "newt", "next", "nice",
             "nick", "nine", "node", "none", "noon", "norm", "nose", "note",
             "noun", "oaks", "oath", "odds", "oils", "once", "ones", "owls",
             "owns", "pace", "pack", "page", "paid", "pail", "pair", "pale",
             "palm", "pane", "pant", "park", "part", "past", "path", "pave",
             "pawn", "paws", "pays", "peak", "pear", "peas", "peat", "peck",
             "peel", "peer", "pens", "perk", "pest", "pets", "pick", "pies",
             "pike", "pile", "pill", "pine", "pins", "pint", "pipe", "pits",
             "plan", "play", "plea", "plot", "plow", "ploy", "plum", "plus",
             "pods", "pole", "poll", "pond", "pool", "poor", "pope", "pork",
             "port", "pose", "post", "pots", "pour", "prep", "prey", "prod",
             "prop", "puff", "pull", "pulp", "pump", "pure", "push", "quit",
             "quiz", "raft", "rage", "rags", "raid", "rail", "rain", "rake",
             "ramp", "rang", "rank", "rant", "rare", "rash", "rate", "rats",
             "rave", "rays", "read", "real", "reap", "rear", "reed", "reef",
             "reel", "rent", "rest", "ribs", "rice", "rich", "ride", "rift",
             "ring", "rink", "ripe", "rise", "risk", "road", "roar", "robe",
             "rock", "rode", "rods", "roll", "roof", "rook", "room", "root",
             "rope", "rose", "rugs", "rule", "rump", "rung", "runs", "runt",
             "rush", "rust", "safe", "sage", "said", "sail", "salt", "same",
             "sand", "sane", "sang", "sash", "save", "saws", "says", "scam",
             "scan", "scar", "seal", "seam", "seas", "seat", "sect", "seed",
             "seek", "seem", "seen", "sees", "self", "sell", "sent", "sets",
             "shed", "shim", "shin", "ship", "shoe", "shop", "shot", "show",
             "shut", "side", "sift", "sigh", "sign", "silk", "sill", "sing",
             "sink", "sins", "site", "sits", "size", "skew", "skid", "skin",
             "skip", "slab", "slap", "slat", "sled", "slid", "slim", "slip",
             "slot", "slow", "slug", "smug", "snag", "snap", "snip", "snow",
             "soak", "soap", "soar", "sock", "soft", "soil", "sold", "sole",
             "some", "song", "sons", "soon", "soot", "sore", "sort", "soul",
             "soup", "spam", "span", "spar", "spin", "spot", "spun", "spur",
             "stab", "stag", "star", "stay", "stem", "step", "stew", "stir",
             "stop", "stow", "stub", "such", "suit", "sump", "sums", "sung",
             "sunk", "suns", "sure", "surf", "swam", "swan", "swap", "swat",
             "sway", "swim", "tabs", "tack", "tags", "tail", "take", "talk",
             "tall", "tang", "tank", "tape", "taps", "task", "teak", "teal",
             "team", "tear", "teas", "teem", "tell", "temp", "tend", "tent",
             "term", "tern", "test", "text", "than", "that", "thaw", "thee",
             "them", "then", "they", "thin", "this", "thus", "tick", "tide",
             "tier", "ties", "tile", "till", "tilt", "time", "tine", "tint",
             "tips", "toad", "toes", "toil", "told", "toll", "tomb", "tone",
             "tong", "took", "tool", "tops", "torn", "tort", "toss", "tour",
             "town", "toys", "tram", "trap", "tray", "tree", "trim", "trip",
             "trod", "true", "tube", "tubs", "tuck", "tune", "turf", "turn",
             "twig", "twin", "type", "urge", "vain", "vase", "vast", "veer",
             "veil", "vent", "verb", "vest", "view", "vine", "vise", "void",
             "vole", "volt", "vote", "vows", "wade", "wage", "wail", "wait",
             "wake", "walk", "wall", "wand", "want", "ward", "ware", "warm",
             "warn", "warp", "wars", "wash", "wasp", "watt", "wave", "weak",
             "wear", "webs", "week", "weep", "weld", "well", "went", "were",
             "west", "what", "when", "whim", "whip", "whom", "wick", "wide",
             "wife", "wigs", "wild", "will", "wind", "wine", "wing", "wink",
             "wins", "wipe", "wise", "wish", "with", "wolf", "wood", "wool",
             "word", "wore", "work", "worm", "worn", "wrap", "wren", "yard",
             "yarn", "yawn", "year", "yell", "your", "zest", "zinc", "zone")

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
