import com.jpexs.decompiler.flash.SWF;
import com.jpexs.decompiler.flash.abc.ABC;
import com.jpexs.decompiler.flash.abc.avm2.parser.script.AbcIndexing;
import com.jpexs.decompiler.flash.abc.avm2.parser.script.ActionScript3Parser;
import com.jpexs.decompiler.flash.tags.ABCContainerTag;
import com.jpexs.decompiler.flash.tags.Tag;
import java.io.*;
import java.nio.file.*;
import java.util.*;

public class AddScript {
  public static void main(String[] a) throws Exception {
    String in = a[0], out = a[1], srcFile = a[2], fileName = a[3];
    SWF swf;
    try (InputStream is = new BufferedInputStream(new FileInputStream(in))) {
      swf = new SWF(is, false);
    }
    List<ABCContainerTag> abcs = swf.getAbcList();
    ABCContainerTag best = null; int bestSize = -1;
    for (ABCContainerTag t : abcs) {
      int n = t.getABC().script_info.size();
      System.out.println("ABC tag with " + n + " scripts");
      if (n > bestSize) { bestSize = n; best = t; }
    }
    ABC abc = best.getABC();
    String src = new String(Files.readAllBytes(Paths.get(srcFile)), "UTF-8");
    AbcIndexing idx = swf.getAbcIndex();
    ActionScript3Parser parser = new ActionScript3Parser(idx);
    int before = abc.script_info.size();
    parser.addScript(src, fileName, 0, before, null, abc);
    System.out.println("scripts: " + before + " -> " + abc.script_info.size());
    ((Tag) best).setModified(true);
    try (OutputStream os = new BufferedOutputStream(new FileOutputStream(out))) {
      swf.saveTo(os);
    }
    System.out.println("saved " + out);
  }
}
