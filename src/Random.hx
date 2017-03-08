package ;

import flash.errors.ArgumentError;
import flash.utils.ByteArray;

// Source: http://www.kirupa.com/forum/showthread.php?365564-AS3-Seeded-Pseudo-Random-Number-Generator
// Converted to Haxe with as3hx
class Random
{
	public var seed(get, never) : Int;

	// Fields
	private var _inext : Int;
	private var _inextp : Int;
	//		private const  MBIG : int = 0x7fffffff;
	//		private const  MSEED : int = 0x9a4ec86;
	//		private const MZ : int = 0;
	private var _seed : Int;
	private var _seedArray : Array<Int>;

	// Methods
	public function new(seed : Int)
	{
		this._seed = seed;
		this._seedArray = new Array<Int>();
		var num2 : Int = Std.int(0x9a4ec86 - Math.abs(seed));
		this._seedArray[0x37] = num2;
		var num3 : Int = 1;
		for (i in 1...0x37)
		{
			var index : Int = Std.int((0x15 * i) % 0x37);
			this._seedArray[index] = num3;
			num3 = Std.int(num2 - num3);
			if (num3 < 0)
			{
				num3 += 0x7fffffff;
			}
			num2 = this._seedArray[index];
		}
		for (j in 1...5)
		{
			for (k in 1...0x38)
			{
				this._seedArray[k] -= this._seedArray[1 + ((k + 30) % 0x37)];
				if (this._seedArray[k] < 0)
				{
					this._seedArray[k] += 0x7fffffff;
				}
			}
		}
		this._inext = 0;
		this._inextp = 0x15;
		seed = 1;
	}

	private function get_seed() : Int
	{
		return this._seed;
	}

	private function getSampleForLargeRange() : Float
	{
		var num : Int = this.internalSample();
		if ((this.internalSample() % 2) == 0)
		{
			num = -num;
		}
		var num2 : Float = num;
		num2 += 2147483646.0;
		return (num2 / 4294967293);
	}

	private function internalSample() : Int
	{
		var inext : Int = this._inext;
		var inextp : Int = this._inextp;
		if (++inext >= 0x38)
		{
			inext = 1;
		}
		if (++inextp >= 0x38)
		{
			inextp = 1;
		}
		var num : Int = Std.int(this._seedArray[inext] - this._seedArray[inextp]);
		if (num < 0)
		{
			num += 0x7fffffff;
		}
		this._seedArray[inext] = num;
		this._inext = inext;
		this._inextp = inextp;
		return num;
	}

	public function nextInt() : Int
	{
		return this.internalSample();
	}

	public function nextMax(maxValue : Int) : Int
	{
		if (maxValue < 0)
		{
			throw new ArgumentError("Argument \"maxValue\" must be positive.");
		}
		return Std.int(this.sample() * maxValue);
	}

	public function nextMinMax(minValue : Int, maxValue : Int) : Int
	{
		if (minValue > maxValue)
		{
			throw new ArgumentError("Argument \"minValue\" must be less than or equal to \"maxValue\".");
		}
		var num : Float = maxValue - minValue;
		if (num <= 0x7fffffff)
		{
			return Std.int((Std.int(this.sample() * num)) + minValue);
		}
		return Std.int((Std.int((this.getSampleForLargeRange() * num))) + minValue);
	}

	public function nextBytes(buffer : ByteArray, length : Int) : Void
	{
		if (buffer == null)
		{
			throw new ArgumentError("Argument \"buffer\" cannot be null.");
		}
		for (i in 0...length)
		{
			buffer.writeByte(this.internalSample() % 0x100);
		}
	}

	public function nextNumber() : Float
	{
		return this.sample();
	}

	private function sample() : Float
	{
		return (this.internalSample()   * 4.6566128752457969E-10  );
	}
}
