
-- a library for all the app audio
-- since audio spans composer screens and 
-- even the game itself, we'll keep everythign here instead of as globals

local settings = require( 'modules.settings' )

local sound = {}


audio.reserveChannels( 1 )

audio.setVolume( settings.music_vol, { channel = 1 } )  -- music track

sound.music = {
	ambience1 = audio.loadStream( 'assets/audio/music/ambience1.mp3' ),
	energy1 = audio.loadStream( 'assets/audio/music/energy1.mp3' )
}

sound.fx = {
	die		= audio.loadSound( 'assets/audio/sounds/die.mp3' ),
	eat 	= audio.loadSound( 'assets/audio/sounds/eat.mp3' ),
	hit 	= audio.loadSound( 'assets/audio/sounds/hit.mp3' ),
	levelup = audio.loadSound( 'assets/audio/sounds/levelup.mp3' ),
}


function sound.playMusic( h )
	--if settings.music then
		audio.play( h, { channel=1, loops=-1 } )
	--end
end


function sound.playSound( h )
	--if settings.fx then
		audio.play( h )
	--end
end

function sound.reset_music( vol )
	print( 'Resetting Music?' )
	audio.stop()
	audio.rewind( { channel=1 } )
	audio.setVolume( settings.music_vol, { channel = 1 } ) -- music track
end



return sound