Sound = {}

-- Is the sound for the game initialized?
local initialized = false

-- Background as separate variable since it will be loaded in as a stream
local background = nil

-- Hold sound effects in a table that will be loaded
local effects = nil

-- Set up and load audio files
function Sound.initialize()
    if initialized then
        return
    end

    -- reserve the first 5 channels for background music and any other special sounds that
    --  we might want to control (volume, etc.) differently from basic sound effects.
    audio.reserveChannels(5)

    -- load in background music as a stream
    background = audio.loadStream("assets/audio/background1.mp3", {channel = 1})

    -- load sound effects
    effects = {
        missile = audio.loadSound("assets/audio/missile.wav"),
        explosion = audio.loadSound("assets/audio/explosion.wav"),
        lurcherAttack = audio.loadSound("assets/audio/lurcherAttack.wav"),
        lurcherLaugh = audio.loadSound("assets/audio/lurcherLaugh.wav")
    }
end

-- Plays background music on a loop
function Sound.playBackground()
    -- Play background music, looping forever
    audio.play(background, {loops = -1})
end

-- Plays a sound one time
function Sound.play(file)
    audio.play(effects[file])
end

-- Dispose of all audio
function Sound.dispose()
    -- stop all channels of audio
    audio.stop()

    -- Dispose of background music
    audio.dispose(background)

    -- Dispose of all effects in the sound table
    for s, v in pairs(effects) do
        audio.dispose(effects[s])
        effects[s] = nil
    end

    initialized = false
end

return Sound