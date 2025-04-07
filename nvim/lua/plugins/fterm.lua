return {
   {
      'numToStr/FTerm.nvim',
      config = function()
          require('FTerm').setup({
              cmd = "bash",
	      border = "rounded",
              dimensions = {
	          height = 0.7,
	          width = 0.6,
	      },
          })
      end,
   },
}
