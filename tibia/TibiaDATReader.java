import java.io.*;
import java.util.Vector;

public class TibiaDATReader {
	private static FileInputStream in = null;
	private static long bytesRead = 0;

	public static void main( String[] args ) { // tests this class
		String datFile = "H:/My Tibia/Tibia EXE's/Tibia 7.8/Tibia.dat";
		if( args.length > 0 ) datFile = args[0]; // if a command line argument was given, use it as the file to load
		try {
			Vector<TibiaItemDescriptor> entries = parseDAT( datFile );
			System.out.println( bytesRead + " bytes and " + entries.size() + " item descriptions were read." );
		} catch( FileNotFoundException e ) {
			System.out.println( "ERROR: Unable to load " + datFile );
		}
	}

	private static char readByte() throws IOException {
		byte[] b = new byte[1]; char ret = 0;
		int i = in.read( b, 0, 1 );
		if( i == -1 ) throw new IOException(); // end of file reached
		if( b[0] < 0 ) ret = (char)(b[0] + 256); else ret = (char)b[0];
		bytesRead++;
		return ret;
	}

	public static Vector<TibiaItemDescriptor> parseDAT( String file ) throws FileNotFoundException {
		in = new FileInputStream( file ); // try to open the file
		Vector<TibiaItemDescriptor> ret = new Vector<TibiaItemDescriptor>();
		try {
			in.skip(12);
			bytesRead = 12;
		} catch( IOException e ) {
		}
		char buffer = 0;
		TibiaItemDescriptor t = new TibiaItemDescriptor();
		while(true) {
			try {
				buffer = readByte();
				switch( buffer ) {
					case 0x00: // ground tile?
						t.isGround = true;
						buffer = readByte();
						t.speedModifier = buffer;
						if( t.speedModifier == 0 ) t.isBlocking = true;
						buffer = readByte(); // always 0...probably second byte for speed modifier
						break;
					case 0x01: // always on top of higher priority?
						t.moreAlwaysOnTop = true;
						break;
					case 0x02: // always on top?
						t.alwaysOnTop = true;
						break;
					case 0x03: // walkable?
						t.isWalkable = true;
						break;
					case 0x04: // is container?
						t.isContainer = true;
						break;
					case 0x05: // is stackable?
						t.isStackable = true;
						break;
					case 0x06: // unknown?
						break;
					case 0x07: // is usable?
						t.isUsable = true;
						break;
					case 0x08: // writable item?
						t.isReadable = true;
						t.isWritable = true;
						t.maxLength = readByte(); // num characters (0 is unlimited)
						t.maxLines = readByte(); // num lines (0, 2, 4, 7)
						break;
					case 0x09: // read-only item?
						t.isReadable = true;
						t.maxLength = readByte(); // num characters
						t.maxLines = readByte(); // always 4 lines?
						break;
					case 0x0a: // fluid container?
						t.isLiquidContainer = true;
						break;
					case 0x0b: // multi type...liquid splatter type (blood, slimes, etc.)
						t.multiType = true;
						break;
					case 0x0c: // is blocking?
						t.isBlocking = true;
						break;
					case 0x0d: // is immovable?
						t.isImmovable = true;
						break;
					case 0x0e: // blocks projectiles?
						t.blocksProjectiles = true;
						break;
					case 0x0f: // unknown?
						break;
					case 0x10: // carryable?
						t.isCarryable = true;
						break;
					case 0x11: // can see below, i.e. ladder trapdoor
						t.canSeeBelow = true;
						break;
					case 0x12: // action possible?
						t.isInteractive = true;
						break;
					case 0x13: // walls 2 types of them same material (total 4 pairs)
						break;
					case 0x14: // unknown?
						break;
					case 0x15: // makes light?
						t.isLightSource = true;
						t.lightRadius = readByte(); // number of tiles around?
						buffer = readByte(); // always 0, unknown (light radius is single byte)
						t.lightColor = readByte(); // typically 215 for items, 208 for non-items
						buffer = readByte(); // always 0, unknown (light color is single byte)
						break;
					case 0x17: // stairs down?
						t.zChangeDown = true;
						break;
					case 0x18: // unknown
						buffer = readByte(); // unknown
						buffer = readByte(); // unknown
						buffer = readByte(); // unknown
						buffer = readByte(); // unknown
						break;
					case 0x19: // blocking pickup-able stacking items (boxes, chairs, etc.)?
						t.blockPickupable = true;
						buffer = readByte(); // always 8, maybe for maximum visible in a stack?
						buffer = readByte(); // always 0
						break;
					case 0x1a: // corpses that don't decay?
						t.noDecay = true;
						break;
					case 0x1b: // wall items
						break;
					case 0x1c: // for minimap drawing?
						buffer = readByte(); // 2 bytes for color
						buffer = readByte();
						break;
					case 0x1d: // line spot?
						buffer = readByte();
						switch( buffer ) {
							case 0x4c: // ladders
								t.zChangeUp = true;
								t.requiresUse = true;
								break;
							case 0x4d: // crate - trapdoor?
								t.requiresUse = true;
								break;
							case 0x4e: // rope spot?
								t.zChangeUp = true;
								t.requiresRope = true;
								break;
							case 0x4f: // switch
								break;
							case 0x50: // doors
								t.isDoor = true;
								break;
							case 0x51: // door with lock
								t.isLockedDoor = true;
								break;
							case 0x52: // stairs to above floor
								t.zChangeUp = true;
								break;
							case 0x53: // mailbox
								break;
							case 0x54: // is depot
								t.isDepot = true;
								break;
							case 0x55: // trash
								break;
							case 0x56: // hole
								t.zChangeDown = true;
								t.requiresShovel = true;
								break;
							case 0x57: // special description?
								break;
							case 0x58: // writable
								t.isReadable = true;
								break;
							default: // should not happen
								System.out.println( "Unknown case " + (int)buffer + " at byte " + (bytesRead - 1) );
								break;
						}
						buffer = readByte(); // always 4
					case 0x1e: // tiles that don't cause floor change?
						t.noZChange = true;
						break;
					case 0xff: // end of item descriptor
						t.graphicWidth = readByte();
						t.graphicHeight = readByte();
						if( t.graphicWidth > 1 || t.graphicHeight > 1 ) buffer = readByte(); // skip a byte
						t.blendFrames = readByte();
						t.xDiv = readByte();
						t.yDiv = readByte();
						t.numAnimationFrames = readByte();
						int rare = readByte();
						long skipCount = t.graphicWidth * t.graphicHeight * t.blendFrames * t.xDiv * t.yDiv * t.numAnimationFrames * rare * 2;
						in.skip( skipCount );
						bytesRead += skipCount;
						ret.add(t); // store the item descriptor
						t = new TibiaItemDescriptor(); // create a new descriptor
						break;
					default:
						System.out.println( "Unknown flag " + (int)buffer + " at byte " + (bytesRead - 1) );
				}
			} catch( IOException e ) {
				return ret;
			}
		}
	}

	public static class TibiaItemDescriptor {
		public int numAnimationFrames = -1;
		public int blendFrames = -1;
		public int xDiv = -1;
		public int yDiv = -1;
		public int graphicWidth = -1;
		public int graphicHeight = -1;
		public boolean noDecay = false;
		public boolean blocksProjectiles = false;
		public boolean isLightSource = false;
		public int lightColor = -1;
		public int lightRadius = -1;
		public boolean isDoor = false;
		public boolean isLockedDoor = false;
		public boolean isCarryable = false;
		public boolean isBlocking = false;
		public boolean isImmovable = false;
		public boolean isGround = false;
		public boolean isWalkable = false;
		public boolean isContainer = false;
		public boolean isStackable = false;
		public boolean isUsable = false;
		public boolean isLiquidContainer = false;
		public boolean isWritable = false;
		public int maxLength = -1;
		public int maxLines = -1;
		public boolean isReadable = false;
		public boolean isDepot = false;
		public boolean isInteractive = false;
		public boolean requiresUse = false;
		public boolean requiresRope = false;
		public boolean requiresShovel = false;
		public boolean alwaysOnTop = false;
		public boolean moreAlwaysOnTop = false;
		public boolean multiType = false;
		public boolean canSeeBelow = false;
		public boolean noZChange = false;
		public boolean zChangeUp = false;
		public boolean zChangeDown = false;
		public boolean blockPickupable = false;
		public int speedModifier = 0;
	}
}
