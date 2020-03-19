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

    -- Reserve the first 5 channels for background music and any other special sounds that
    -- we might want to control (volume, etc.) differently from basic sound effects.
    audio.reserveChannels(5)

    -- load in background music as a stream
    background = audio.loadStream("audio/test.wav")

    -- load sound effects
    effects = {
        depart = audio.loadSound("audio/depart.wav"),
        missile = audio.loadSound("audio/missile.wav"),
        explosion = audio.loadSound("audio/explosion.wav"),
        lurcherAttack = audio.loadSound("audio/lurcherAttack.wav"),
        lurcherLaugh = audio.loadSound("audio/lurcherLaugh.wav"),
        orb = audio.loadSound("audio/orb.wav")
    }
end 

-- Plays background music on a loop
function Sound.playBackground()
    -- Ensure channel one is at the right volume
    audio.setVolume(1, { channel = 1 } )

    -- Play background music, looping forever
    audio.play(background, { loops = -1, channel = 1 })
end

-- Slowly stops the background music
function Sound.stopBackground()
    -- Stops background music slowly
    audio.fadeOut({ channel = 1, time = 10000 })
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
