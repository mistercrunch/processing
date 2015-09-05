import rwmidi.*;
MidiInput input;
MidiOutput output;

void noteOnReceived(Note note) {
        if(note.getVelocity() != 0)
        {
          MyKeySet.keys[note.getPitch()].LatestVelocity = note.getVelocity(); 
          KeysPushed.add(MyKeySet.keys[note.getPitch()]);
        }
        else
        {
          KeysReleased.add(MyKeySet.keys[note.getPitch()]);
        }
}

void noteOffReceived(Note note) {
//Assynchronous midi note received message
          KeysReleased.add(MyKeySet.keys[note.getPitch()]);
}


