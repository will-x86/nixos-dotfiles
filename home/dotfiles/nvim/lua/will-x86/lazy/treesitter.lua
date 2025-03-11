return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        require 'nvim-treesitter.configs'.setup {
            ensure_installed = {
                "javascript",
                "typescript",
                "tsx", -- Add this
                "jsx", -- Add this
                "c",
                "lua",
                "vim"
            },
            sync_install = false,
            auto_install = true,
            -- Remove this line as it's preventing JavaScript parser installation
            -- ignore_install = { "javascript" },
            highlight = {
                enable = true,
                disable = function(lang, buf)
                    if lang == "html" then
                        print("disabled")
                        return true
                    end

                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        vim.notify(
                            "File larger than 100KB treesitter disabled for performance",
                            vim.log.levels.WARN,
                            { title = "Treesitter" }
                        )
                        return true
                    end
                end,
                additional_vim_regex_highlighting = false,
            },
            -- Add this section
            autotag = {
                enable = true,
                enable_rename = true,
                enable_close = true,
                enable_close_on_slash = true,
            },
        }
    end
}

