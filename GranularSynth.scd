//Just evaluate this whole code

(
//n = NetAddr.new("127.0.0.1", 12000); //local ip address for testing
n = NetAddr.new("192.168.43.1", 12000); //remote ip address for playing
~ctrlbus = Bus.alloc('control', s, 2); //control bus for the FFT chain to be read
//~buf = Buffer.read(s,"/Users/Ste/Google Drive/Ste/Musica Elettronica/Processing/Progetto Sistemi II/Sine.wav"); //buffer
~buf1 = Buffer.readChannel(s, "/Users/Ste/Google Drive/Ste/Percussa Tool Box Samples/SeedShellShaker1.wav", channels:[1] );
~buf2 = Buffer.readChannel(s, "/Users/Ste/Google Drive/Ste/Musica Elettronica/Composizione/Part2/saw.wav", channels:[1]);
~buf3 = Buffer.readChannel(s, "/Users/Ste/Google Drive/Ste/Musica Elettronica/Composizione/Part2/oboe.wav", channels:[1]);
~buf4 = Buffer.readChannel(s, "/Users/Ste/Google Drive/Ste/Musica Elettronica/Composizione/Part2/hiss.wav", channels:[1]);


SynthDef(\grain, { //SYNTH DEFINITION
	arg buf, dur, rate, pos, dens, out, gate;
	var sig, env, envG, chain, perc, envVol;

	env = EnvGen.kr(Env.adsr, doneAction:2);
	envG = EnvGen.kr(Env.sine(0.1, 10));

	envVol = EnvGen.kr(
		Env.asr(0.2, 1, 1), gate);

	sig = GrainBuf.ar(2, Impulse.kr(dens), dur, buf, rate, pos, 4, 0, -1, 512)*env;
	sig = Limiter.ar(sig, 0.5)*envVol;
	chain = FFT(LocalBuf(2048), sig);
	perc = SpecCentroid.kr(chain);
	Out.kr(~ctrlbus, perc);
	Out.ar(0, sig);
}).add;

OSCdef.new(  //A function to receive an osc message to start the synth on the server, once it arrives the synth start playing
	\buf,
	{
		arg msg;
		//msg.postln;
		~synth = Synth(\grain, [\buf, ~buf1,\dur, 0.5,\rate, 1, \dens, 1, \pos, 0.5, \gate, 1]);
	},
	'/buf'
);

OSCdef.new( //A function to receive an osc message with the size of the screen on which the mapping will occur
	\size,
	{
		arg msg;
		msg.postln;
		~width = msg[1];
		~height = msg[2];
		},
	'/size'
);

OSCdef.new(\msg, //A function to receive an osc message everytime something moves on the controller, it also maps the function to our chosen values. Sends the color information to the processing sketch
	{
		arg msg;
		var x, y;
		x = msg[1];
		y = msg[2];
		~synth.set(\dens, msg[1].linexp(0, ~width, 1, 700).lag(0.25));
		~synth.set(\dur, msg[2].linexp(0, ~height, 3, 0.001).lag(0.25));
		~ctrlbus.getn(2, {|val| {val}.defer(0.5);
			n.sendMsg("/color", val[0]);
		});
	},
	'/msg'
);

OSCdef.new(\kill, //kills the synth at the exit of the processing sketch
	{
		arg msg;
		~synth.free;
	},
	'/kill'
);

OSCdef.new(\gateoff,
	{
		arg msg;
		~synth.set(\gate, 0);
	},
	'/gateoff'
);

OSCdef.new(\gateon,
	{
		arg msg;
		~synth.set(\gate, 1);
	},
	'/gateon'
);

OSCdef.new(\changeBuf,
	{
		arg msg;
		case
		{msg[1] == 1}{~synth.set(\buf, ~buf1)}
		{msg[1] == 2}{~synth.set(\buf, ~buf2)}
		{msg[1] == 3}{~synth.set(\buf, ~buf3)}
		{msg[1] == 4}{~synth.set(\buf, ~buf4)}
	},
	'/changeBuf'
);
)

//SUPER EASY TEST con oscP5sendreceive.pde

(
OSCdef.new(\test,
	{
		arg msg;
		msg.postln;
	},
	'/test',
);
)