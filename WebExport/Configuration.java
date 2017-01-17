////////////////////////////////////////////////////////////////////////
// Class file to handle Name, Value pair files commonly known as INI  //
// files under the MS-Windows environment.                            //
// This version does not handle Groups in the INI file concept.       //
//                                                                    //
// Modified to acknowledge lines with # as reminder in the file       //
//                                                                    //
// Developed by: Devraj Mukherjee                                     //
//                                                                    //
// Mehtods description:                                               //
//                                                                    //
// Configuration(String)    -  The String is the file_name that the   //
//                          constructor needs to read from            //
// Configuration()       -  Opens a defualt INI registry in memory    //
// getValue(String)      -  Gets the value for a entered String Key   //
//                          Returns null if the key is not found      //
// setValue(String)      -  Sets the value for a entered String Key   //
//                          If the key exists in the table, then the  //
//                          value is updated.                         //
// write()               -  Writes INI values to the current file     //
// writeAs(String)       -  Writes INI values to specified file       //
// newFile(String)       -  Changes the file name and clears values   //
// elements()            -  Returns the number of elements            //
////////////////////////////////////////////////////////////////////////
import java.io.*;
import java.util.Hashtable;
import java.util.Enumeration;

public class Configuration {

 protected Hashtable iniElements;
 protected String filename;
 PrintWriter file_out;
 BufferedReader file_in;
 
 public Configuration(String file_name) throws IOException {
  filename=file_name;
  iniElements=new Hashtable();

  try { file_in=new BufferedReader(new FileReader(filename)); }
  catch (IOException e) {
   System.out.println("INI File handler - error opening file "+file_name);
   return;
  }
  String input=file_in.readLine();
  while(input!=null) {
   if(input.length()==0) {
    input=file_in.readLine();
    continue;
   }
   if (input.indexOf("=")>0 && !(input.substring(0,1).equals("#"))) {
    String name=input.substring(0,input.indexOf("="));
    String value=input.substring(input.indexOf("=")+1, input.length());
    iniElements.put(name,value);
   }
   input=file_in.readLine();
  }
  file_in.close();
 }//end constructor

 public Configuration() throws IOException {
  iniElements=new Hashtable();
  filename="";
 }

 public String getValue(String in_key) {
  return ((String)iniElements.get(in_key));
 }

 public void setValue(String in_key, String in_value) {
  iniElements.put(in_key,in_value);
 } 

 public void write() throws IOException {
  String value="",name="";
  try { file_out=new PrintWriter(new BufferedWriter(new FileWriter(filename))); }
  catch (IOException e) {
   System.out.println("INI Handler - Error opening INI file for writing");
   System.out.println("Requested file: "+filename);
  }
  for (Enumeration enum = iniElements.keys() ; enum.hasMoreElements() ;) {
   name=(String)enum.nextElement();
   value=(String)iniElements.get(name);
   file_out.println(name+"="+value);
  }
  file_out.close();
 }

 public void writeAs(String in_file) throws IOException {
  filename=in_file;
  write();
 }

 public void newFile(String in_file) throws IOException {
  filename=in_file;
  iniElements.clear();
 }

 public int elements() { return iniElements.size(); }
}
