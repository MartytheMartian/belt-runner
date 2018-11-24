-- TODO: Need to reorganize this a bit if loading in different sounds per level
--       For now, assuming same sounds throughout game

local M = {}

-- Is the sound for the game initialized?
local initialized = false

-- Background as separate variable since it will be loaded in as a stream
local backgroundMusic = nil

-- Hold sound effects in a table that will be loaded
local effectSoundTable = nil

-- Set up and load audio files
function M.initializeAudio()
    if not initialized then
        -- reserve the first 5 channels for background music and any other special sounds that
        --  we might want to control (volume, etc.) differently from basic sound effects.
        audio.reserveChannels(5)

        -- load in background music as a stream
        backgroundMusic = audio.loadStream("assets/audio/genericBackMusic.mp3", {channel = 1})

        -- load sound effects
        effectSoundTable = {
            basicMissileSound = audio.loadSound("assets/audio/basicMissile.wav"),
            basicExplosionSound = audio.loadSound("assets/audio/basicExplosion.wav"),
            lurcherAttackSound = audio.loadSound("assets/audio/lurcherAttack.wav"),
            lurcherLaughSound = audio.loadSound("assets/audio/lurcherLaugh.wav")
        }
    end
end

function M.playBackgroundMusic()
    -- Play background music, looping forever
    audio.play(backgroundMusic, {loops = -1})
end

function M.playMissleSound()
    audio.play(effectSoundTable["basicMissileSound"])
end

function M.playBasicExplosionSound()
    audio.play(effectSoundTable["basicExplosionSound"])
end

function M.playLurcherAttackSound()
    audio.play(effectSoundTable["lurcherAttackSound"])
end

function M.playLurcherLaughSound()
    audio.play(effectSoundTable["lurcherLaughSound"])
end

function M.disposeAudio()
    -- stop all channels of audio
    audio.stop()

    -- Dispose of background music
    audio.dispose(backgroundMusic)

    -- Dispose of all effects in the sound table
    for s, v in pairs(effectSoundTable) do
        audio.dispose(effectSoundTable[s])
        effectSoundTable[s] = nil
    end

    initialized = false
end

return M
