# Arduino-Nvim

A Neovim plugin that provides Arduino IDE-like functionality directly in your editor. This plugin integrates Arduino development tools with Neovim, offering a seamless development experience for Arduino projects.

## Features

- Arduino project compilation and verification
- Code upload to Arduino boards
- Serial monitor with writeable interface
- Board and port management with GUI selection
- Advanced library management with Telescope integration
  - Visual indicators for installed libraries (✅)
  - Update detection and management (🔄)
  - Cached library data for faster loading
- LSP support for Arduino development
- Real-time status monitoring
- Persistent configuration storage

## Requirements

- [arduino-cli](https://arduino.github.io/arduino-cli/) (latest stable version)
- [arduino-language-server](https://github.com/arduino/arduino-language-server) (patched version required - see [Patch](https://github.com/arduino/arduino-language-server/issues/187#issuecomment-2241641098))
- [clangd](https://clangd.llvm.org/) (latest stable version)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)

## Installation

1. Clone the repository:
```sh
git clone https://github.com/yuukiflow/Arduino-Nvim.git ~/.config/nvim/lua/Arduino-Nvim
```

2. Add the following to your `init.lua`:
```lua
-- Load LSP configuration first
require("Arduino-Nvim.lsp").setup()

-- Set up Arduino file type detection
vim.api.nvim_create_autocmd("FileType", {
    pattern = "arduino",
    callback = function()
        require("Arduino-Nvim")
    end
})
```

## Usage

All commands are prefixed with `<Leader>a` followed by a single letter indicating the action:

| Command | Description |
|---------|-------------|
| `<Leader>ac` | Compile and verify the current sketch |
| `<Leader>au` | Upload sketch to board (configures port and FQBN) |
| `<Leader>am` | Open serial monitor in a floating terminal |
| `<Leader>as` | Display current board, port, and FQBN status |
| `<Leader>al` | Open library manager (Telescope interface) |
| `<Leader>ag` | Open GUI for setting board and port |
| `<Leader>ap` | List available ports |
| `<Leader>ab` | List available boards |

### Configuration

The plugin automatically creates and manages a `.arduino_config.lua` file in your project directory to store:
- Board type (FQBN)
- Port selection
- Baudrate settings

### Serial Monitor Configuration

Set the baudrate for the serial monitor using:
```
:InoSetBaudrate 115200
```
Default baudrate is 115200 if not specified.

### Library Manager

The library manager provides a Telescope interface with the following features:
- Visual indicators for installed libraries (✅)
- Update detection for outdated libraries (🔄)
- One-click installation and updates
- Cached library data for improved performance
- Search and filter capabilities

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is completely free and open source. You can do whatever you want with the code:
- Use it for any purpose
- Modify it however you want
- Share it with anyone
- Use it commercially
- Use it privately

No attribution or license text is required. Feel free to use this code in any way that helps you.
