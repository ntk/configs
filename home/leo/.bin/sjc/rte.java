package java.lang;
import rte.SClassDesc;
public class Object {
  public SClassDesc _r_type;
  public Object _r_next;
  public int _r_relocEntries, _r_scalarSize;
}
package java.lang;
public class String {
  private char[] value;
  private int count;
  public int length() {
    MARKER.inline();
    return count;
  }
  public char charAt(int i) {
    MARKER.inline();
    return value[i];
  }
}
package rte;
public class SArray {
  public int length, _r_dim, _r_stdType;
  public SClassDesc _r_clssType;
}
package rte;
public class SClassDesc {
  public SClassDesc parent;
  public SIntfMap implementations;
}
package rte;
public class SIntfDesc {
}
package rte;
public class SIntfMap {
  public SIntfDesc owner;
  public SIntfMap next;
}
package rte;
public class SMthdBlock {
}
package rte;
public class DynamicRuntime {
  public static Object newInstance(int scalarSize, int relocEntries,
      SClassDesc type) { while(true); }
  public static SArray newArray(int length, int arrDim, int entrySize,
      int stdType, SClassDesc clssType) { while(true); }
  public static void newMultArray(SArray[] parent, int curLevel,
      int destLevel, int length, int arrDim, int entrySize, int stdType,
      SClassDesc clssType) { while(true); }
  public static boolean isInstance(Object o, SClassDesc dest,
      boolean asCast) { while(true); }
  public static SIntfMap isImplementation(Object o, SIntfDesc dest,
      boolean asCast) { while(true); }
  public static boolean isArray(SArray o, int stdType,
      SClassDesc clssType, int arrDim, boolean asCast) { while(true); }
  public static void checkArrayStore(Object dest,
      SArray newEntry) { while(true); }
}
