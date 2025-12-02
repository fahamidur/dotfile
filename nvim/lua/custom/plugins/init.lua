return {
	require("custom.plugins.cpp_config"),

	require("lazy").setup({
	  require("custom.plugins.markdown"),
	  -- other plugin specs...
	})
}
