import 'character.dart';

Map<int, int> legionCoinCap = {

};

Map<int, int> levelExp = {
  1: 15,
  2: 34,
  3: 57,
  4: 92,
  5: 135,
  6: 372,
  7: 560,
  8: 840,
  9: 1242,
  10: 1242,
  11: 1242,
  12: 1242,
  13: 1242,
  14: 1242,
  15: 1490,
  16: 1788,
  17: 2145,
  18: 2574,
  19: 3088,
  20: 3705,
  21: 4446,
  22: 5335,
  23: 6402,
  24: 7682,
  25: 9218,
  26: 11061,
  27: 13273,
  28: 15927,
  29: 19112,
  30: 19112,
  31: 19112,
  32: 19112,
  33: 19112,
  34: 19112,
  35: 22934,
  36: 27520,
  37: 33024,
  38: 39628,
  39: 47553,
  40: 51357,
  41: 55465,
  42: 59902,
  43: 64694,
  44: 69869,
  45: 75458,
  46: 81494,
  47: 88013,
  48: 95054,
  49: 102658,
  50: 110870,
  51: 119739,
  52: 129318,
  53: 139663,
  54: 150836,
  55: 162902,
  56: 175934,
  57: 190008,
  58: 205208,
  59: 221624,
  60: 221624,
  61: 221624,
  62: 221624,
  63: 221624,
  64: 221624,
  65: 238245,
  66: 256113,
  67: 275321,
  68: 295970,
  69: 318167,
  70: 342029,
  71: 367681,
  72: 395257,
  73: 424901,
  74: 456768,
  75: 488741,
  76: 522952,
  77: 559558,
  78: 598727,
  79: 640637,
  80: 685481,
  81: 733464,
  82: 784806,
  83: 839742,
  84: 898523,
  85: 961419,
  86: 1028718,
  87: 1100728,
  88: 1177778,
  89: 1260222,
  90: 1342136,
  91: 1429374,
  92: 1522283,
  93: 1621231,
  94: 1726611,
  95: 1838840,
  96: 1958364,
  97: 2085657,
  98: 2221224,
  99: 2365603,
  100: 2365603,
  101: 2365603,
  102: 2365603,
  103: 2365603,
  104: 2365603,
  105: 2519367,
  106: 2683125,
  107: 2857528,
  108: 3043267,
  109: 3241079,
  110: 3451749,
  111: 3676112,
  112: 3915059,
  113: 4169537,
  114: 4440556,
  115: 4729192,
  116: 5036589,
  117: 5363967,
  118: 5712624,
  119: 6083944,
  120: 6479400,
  121: 6900561,
  122: 7349097,
  123: 7826788,
  124: 8335529,
  125: 8877338,
  126: 9454364,
  127: 10068897,
  128: 10723375,
  129: 11420394,
  130: 12162719,
  131: 12953295,
  132: 13795259,
  133: 14691950,
  134: 15646926,
  135: 16663976,
  136: 17747134,
  137: 18900697,
  138: 20129242,
  139: 21437642,
  140: 22777494,
  141: 24201087,
  142: 25713654,
  143: 27320757,
  144: 29028304,
  145: 30842573,
  146: 32770233,
  147: 34818372,
  148: 36994520,
  149: 39306677,
  150: 41763344,
  151: 44373553,
  152: 47146900,
  153: 50093581,
  154: 53224429,
  155: 56550955,
  156: 60085389,
  157: 63840725,
  158: 67830770,
  159: 72070193,
  160: 76574580,
  161: 81360491,
  162: 86445521,
  163: 91848366,
  164: 97588888,
  165: 103688193,
  166: 110168705,
  167: 117054249,
  168: 124370139,
  169: 132143272,
  170: 138750435,
  171: 145687956,
  172: 152972353,
  173: 160620970,
  174: 168652018,
  175: 177084618,
  176: 185938848,
  177: 195235790,
  178: 204997579,
  179: 215247457,
  180: 226009829,
  181: 237310320,
  182: 249175836,
  183: 261634627,
  184: 274716358,
  185: 288452175,
  186: 302874783,
  187: 318018522,
  188: 333919448,
  189: 350615420,
  190: 368146191,
  191: 386553500,
  192: 405881175,
  193: 426175233,
  194: 447483994,
  195: 469858193,
  196: 493351102,
  197: 518018657,
  198: 543919589,
  199: 571115568,
  200: 2207026470,
  201: 2471869646,
  202: 2768494003,
  203: 3100713283,
  204: 3472798876,
  205: 3889534741,
  206: 4356278909,
  207: 4879032378,
  208: 5464516263,
  209: 6120258214,
  210: 9792413142,
  211: 10869578587,
  212: 12065232231,
  213: 13392407776,
  214: 14865572631,
  215: 19325244420,
  216: 21064516417,
  217: 22960322894,
  218: 25026751954,
  219: 27279159629,
  220: 43646655406,
  221: 46701921284,
  222: 49971055773,
  223: 53469029677,
  224: 57211861754,
  225: 74375420280,
  226: 78094191294,
  227: 81998900858,
  228: 86098845900,
  229: 90403788195,
  230: 144646061112,
  231: 148985442945,
  232: 153455006233,
  233: 158058656419,
  234: 162800416111,
  235: 211640540944,
  236: 217989757172,
  237: 224529449887,
  238: 231265333383,
  239: 238203293384,
  240: 381125269414,
  241: 392559027496,
  242: 404335798320,
  243: 416465872269,
  244: 428959848437,
  245: 557647802968,
  246: 574377237057,
  247: 591608554168,
  248: 609356810793,
  249: 627637515116,
  250: 1004220024186,
  251: 1034346624911,
  252: 1065377023658,
  253: 1097338334367,
  254: 1130258484398,
  255: 1164166238929,
  256: 1199091226096,
  257: 1235063962878,
  258: 1272115881764,
  259: 1310279358216,
  260: 2902427248153,
  261: 2931451520634,
  262: 2960766035840,
  263: 2990373696198,
  264: 3020277433159,
  265: 3050480207490,
  266: 3080985009564,
  267: 3111794859659,
  268: 3142912808255,
  269: 3174341936337,
  270: 6412170711400,
  271: 6476292418514,
  272: 6541055342699,
  273: 6606465896125,
  274: 6672530555086,
  275: 13478511721273,
  276: 14826362893400,
  277: 16308999182740,
  278: 17939899101014,
  279: 19733889011115,
  280: 39862455802452,
  281: 43848701382697,
  282: 48233571520966,
  283: 53056928673062,
  284: 58362621540368,
  285: 117892495511543,
  286: 129681745062697,
  287: 142649919568966,
  288: 156914911525862,
  289: 172606402678448,
  290: 348664933410464,
  291: 383531426751510,
  292: 421884569426661,
  293: 464073026369327,
  294: 510480329006259,
  295: 1031170264592640,
  296: 1134287291051900,
  297: 1247716020157090,
  298: 1372487622172800,
  299: 2058731433259209,
  300: 1,
};

int totalExp(int level) {
  int total = 0;
  for (var entry in levelExp.entries) {
    if (entry.key == level) {
      break;
    }
    total += entry.value;
  }
  return total;
}

int expDiff(int currentLevel, int currentExp, int prevLevel, int prevExp) {
  int total = 0;
  for (var i = prevLevel; i < currentLevel; i++) {
    total += levelExp[i]!;
  }
  total += currentExp - prevExp;

  return total;
}

double calcOneDay(List<DayExp> l) {
  if (l.length < 2) {
    return 0;
  }
  final curr = l[l.length - 1];
  final prev = l[l.length - 2];
  final nextLevel = (((curr.level + 1) / 5).ceil()) * 5;
  final oneDayExp = expDiff(curr.level, curr.exp, prev.level, prev.exp);
  final needExp = expDiff(nextLevel, 0, curr.level, curr.exp);

  if (oneDayExp == 0) {
    return 0;
  }
  return needExp / oneDayExp;
}
