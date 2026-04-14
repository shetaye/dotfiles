return {
	{
		"rose-pine/neovim",
		-- lazy = false,
		-- priority = 1000,
    -- config = function()
    --   --vim.cmd([[colorscheme rose-pine]])
    -- end,
	},
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      vim.cmd([[colorscheme kanagawa]])
    end,
    opts = {
      theme = "dragon",
      background = {
        dark = "dragon",
        light = "lotus",
      },
      theme = {
        dragon = {
          ui = {
            bg_dim = "#000000"
          },
        },
      },
      colors = {
        palette = {
          -- Bg Shades
          -- sumiInk0 = "#030102",  -- Your black
          -- sumiInk1 = "#1A151A",  -- Slightly lighter, purple-tinted black
          -- sumiInk2 = "#2A212A",  -- Another step lighter
          -- sumiInk3 = "#423742",  -- Your "dark gray" with a purple cast
          -- sumiInk4 = "#5B4A5B",  -- Midway gray
          -- sumiInk5 = "#6F5A6F",  -- Soft violet-gray
          -- sumiInk6 = "#816D81",  -- Your gray, used here as the lightest background

          -- -- Popup and Floats (blueish / indigo hint)
          -- waveBlue1 = "#2B283F", -- Darker tone referencing your #8380B9
          -- waveBlue2 = "#3C3760", -- A bit lighter but still subdued

          -- -- Diff and Git
          -- -- Mapping your green (#6D8F52), orange (#FF7358), brown (#A06A3D), and indigo (#8380B9)
          -- winterGreen  = "#2F3928", -- Darkened green background
          -- winterYellow = "#3E3529", -- Dark brownish background
          -- winterRed    = "#3F1F1A", -- Darkened orange/red background
          -- winterBlue   = "#2D2B3F", -- Darkened indigo background
          -- autumnGreen  = "#6D8F52", -- Your dark green
          -- autumnRed    = "#FF7358", -- Your orange
          -- autumnYellow = "#A06A3D", -- Your brown-ish

          -- -- Diag
          -- samuraiRed   = "#FF7358", -- Keep consistent with your orange
          -- roninYellow  = "#CC8A4B", -- Slightly warmer yellow-brown
          -- waveAqua1    = "#5F2A48", -- Using your dark purple as an “aqua” accent
          -- dragonBlue   = "#8380B9", -- Your indigo

          -- -- Fg and Comments
          -- -- Here #FFD8FF functions as the brightest highlight or “white”
          -- oldWhite  = "#CDB8CD",  -- A softer pale violet
          -- fujiWhite = "#FFD8FF",  -- Your off-white (light purple)
          -- fujiGray  = "#9F8E9F",  -- Mid-gray for subdued text

          -- -- Additional Violets/Blues
          -- oniViolet    = "#A876A8",
          -- oniViolet2   = "#BBA1BB",
          -- crystalBlue  = "#9B96CA",
          -- springViolet1 = "#A28FA6",
          -- springViolet2 = "#B2A6C1",
          -- springBlue   = "#9FA4CA",
          -- lightBlue    = "#BABEE0",
          -- waveAqua2    = "#8CA89F",

          -- -- Greens/Yellows
          -- springGreen  = "#819A5C",
          -- boatYellow1  = "#8A6C4B",
          -- boatYellow2  = "#B19572",
          -- carpYellow   = "#CAB49A",

          -- -- Pinks/Reds/Oranges
          -- sakuraPink   = "#CB768F",
          -- waveRed      = "#E46876",
          -- peachRed     = "#F77A75",
          -- surimiOrange = "#FF9366",
          -- katanaGray   = "#717C7C",

          -- -- Dragon Blacks/Whites (less critical, but adjusted to fit overall tone)
          -- dragonBlack0 = "#0A090A",
          -- dragonBlack1 = "#141214",
          -- dragonBlack2 = "#1E1B1E",
          -- dragonBlack3 = "#282528",
          -- dragonBlack4 = "#393539",
          -- dragonBlack5 = "#4B444B",
          -- dragonBlack6 = "#766E76",

          -- dragonWhite = "#E8D2E8",
          -- dragonGreen = "#7F996F",
          -- dragonGreen2 = "#868F72",
          -- dragonPink = "#B79CB8",
          -- dragonOrange = "#C38469",
          -- dragonOrange2 = "#C98F74",
          -- dragonGray = "#A8A3A0",
          -- dragonGray2 = "#9E9A95",
          -- dragonGray3 = "#7A737A",
          -- dragonBlue2 = "#8F8ABC",
          -- dragonViolet= "#9E95B0",
          -- dragonRed   = "#D4756E",
          -- dragonAqua  = "#8EA4A2",
          -- dragonAsh   = "#737C73",
          -- dragonTeal  = "#9CA3B5",
          -- dragonYellow= "#C2AA88",

          -- -- Lotus colors can remain or be replaced similarly, if desired
          -- lotusInk1   = "#4A404E",
          -- lotusInk2   = "#3F3B52",
          -- lotusGray   = "#DCD7BA",
          -- lotusGray2  = "#7E7A73",
          -- lotusGray3  = "#98948D",
          -- lotusWhite0 = "#CFC6A5",
          -- lotusWhite1 = "#D9D0AD",
          -- lotusWhite2 = "#E4DBB2",
          -- lotusWhite3 = "#F1E7BD",
          -- lotusWhite4 = "#E8DBA2",
          -- lotusWhite5 = "#E5D79B",
          -- lotusViolet1= "#A699AA",
          -- lotusViolet2= "#7C7290",
          -- lotusViolet3= "#C9CBD1",
          -- lotusViolet4= "#6D5583",
          -- lotusBlue1  = "#C1D2DD",
          -- lotusBlue2  = "#A9C1CC",
          -- lotusBlue3  = "#97ADC6",
          -- lotusBlue4  = "#4E6191",
          -- lotusBlue5  = "#5C57A0",
          -- lotusGreen  = "#6F894E",
          -- lotusGreen2 = "#6E915F",
          -- lotusGreen3 = "#B7D0AE",
          -- lotusPink   = "#B35B79",
          -- lotusOrange = "#CC6D00",
          -- lotusOrange2= "#E98A00",
          -- lotusYellow = "#77713F",
          -- lotusYellow2= "#836F4A",
          -- lotusYellow3= "#DE9800",
          -- lotusYellow4= "#F9D791",
          -- lotusRed    = "#C84053",
          -- lotusRed2   = "#D7474B",
          -- lotusRed3   = "#E82424",
          -- lotusRed4   = "#D9A594",
          -- lotusAqua   = "#597B75",
          -- lotusAqua2  = "#5E857A",
          -- lotusTeal1  = "#4E8CA2",
          -- lotusTeal2  = "#6693BF",
          -- lotusTeal3  = "#5A7785",
          -- lotusCyan   = "#D7E3D8",
        }
      }
    },
  },
  { "jeffkreeftmeijer/vim-dim" },
  { "morhetz/gruvbox" },
}
