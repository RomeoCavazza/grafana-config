local mocha = {
  base: '#1e1e2e',
  mantle: '#181825',
  crust: '#11111b',
  surface0: '#313244',
  surface1: '#45475a',
  surface2: '#585b70',

  text: '#cdd6f4',
  subtext1: '#bac2de',
  subtext0: '#a6adc8',
  overlay2: '#9399b2',

  blue: '#89b4fa',
  sapphire: '#74c7ec',
  sky: '#89dceb',
  teal: '#94e2d5',
  lavender: '#b4befe',
  mauve: '#cba6f7',
  pink: '#f5c2e7',
  flamingo: '#f2cdcd',

  green: '#a6e3a1',
  yellow: '#f9e2af',
  peach: '#fab387',
  maroon: '#eba0ac',
  red: '#f38ba8',
};

local theme = mocha + {
  base: '#050513',
  mantle: '#0d0f2e',
  crust: '#050513',
  surface0: '#0e184a',
  surface1: '#202b60',
  surface2: '#2b529e',

  text: '#f6fbff',
  subtext1: '#d8f7fb',
  subtext0: '#96cbd2',
  overlay2: '#73d9f7',

  teal: '#94e2d5',
  sky: '#73d9f7',
  sapphire: '#2f9de5',
  blue: '#5d9ae1',
  cyan: '#8df4ec',
  pink: '#f5c2e7',
  lavender: '#b48efa',
  mauve: '#a56c89',

  green: '#94e2d5',
  yellow: '#73d9f7',
  peach: '#b48efa',
  maroon: '#a56c89',
  red: '#f5c2e7',
};

local colors = {
  seaglass: {
    primary: '#94e2d5',
    secondary: '#73d9f7',
    tertiary: '#5d9ae1',
    quaternary: '#b48efa',
    glow: '#8df4ec',
  },

  ok: theme.teal,
  warn: theme.sky,
  hot: theme.lavender,
  crit: theme.pink,
  info: theme.blue,
  accent: theme.teal,

  series: [
    theme.teal,
    theme.blue,
    theme.lavender,
    theme.pink,
    theme.sky,
    theme.mauve,
    theme.cyan,
    '#6aa6ff',
  ],

  mocha: mocha,
  theme: theme,
};

local strip = function(h) if std.startsWith(h, '#') then std.substr(h, 1, 6) else h;
local hexToRgb = function(h)
  local n = std.parseHex(strip(h));
  {
    r: std.floor(n / 65536) % 256,
    g: std.floor(n / 256) % 256,
    b: n % 256,
  };

local pad2 = function(s) if std.length(s) < 2 then '0' + s else s;
local intToHex2 = function(n)
  local v = if n < 0 then 0 else if n > 255 then 255 else std.floor(n + 0.5);
  pad2(std.format('%x', v));

local rgbToHex = function(r, g, b) '#' + intToHex2(r) + intToHex2(g) + intToHex2(b);
local lerp = function(a, b, t) a + (b - a) * t;
local lerpColor = function(h1, h2, t)
  local c1 = hexToRgb(h1);
  local c2 = hexToRgb(h2);
  rgbToHex(lerp(c1.r, c2.r, t), lerp(c1.g, c2.g, t), lerp(c1.b, c2.b, t));

{
  mocha:: mocha,
  theme:: theme,
  colors:: colors,
  lerpColor:: lerpColor,
}
