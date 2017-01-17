//////////////////////////////////////////////////////////////////////////
// Console Input/Output class                                           //
//                                                                      //
// @author: Devraj Mukherjee                                            //
// @version: 1                                                          //
// Last Updated: 10th September 2000                                    //
//                                                                      //
// Constructor:                                                         //
// Console() - Creates a console object                                 //
//                                                                      //
// Methods:                                                             //
// print(String) - Prints a string to the Console window                //
// print(String,boolean) - Prints a String to the Console window        //
//                         true for boolean param, changes line         //
// setConsoleName(String) - sets a String name for the Console object   //
// getConsoleName() - returns the name of the standard input            //
// readString() - returns a String read from the standard input         //
// readInt() - returns an Int read from the Keyboard                    //
// readDouble() - return a Double read from standard input              //
//////////////////////////////////////////////////////////////////////////

import java.io.*;

public class Console extends Object {

 ////////////////////////////////////////////////////////////////////////
 // Instance Variables                                                 //
 ////////////////////////////////////////////////////////////////////////
 
 BufferedReader reader;

 ////////////////////////////////////////////////////////////////////////
 // Constructors                                                       //
 ////////////////////////////////////////////////////////////////////////

 public Console() {
  reader=new BufferedReader(new InputStreamReader(System.in));
 }

 ////////////////////////////////////////////////////////////////////////
 // Output methods                                                     //
 ////////////////////////////////////////////////////////////////////////

 public void print(String message) {
  System.out.println(message);
 }

 public void print(String message, boolean endline) {
  if (endline) System.out.println(message);
  else System.out.print(message);
 }

 public void println(String message) {
  System.out.println(message);
 }

 ////////////////////////////////////////////////////////////////////////
 // Input methods                                                      //
 ////////////////////////////////////////////////////////////////////////

 public String readString() throws IOException
 { return reader.readLine(); }

 public String readString(String message) throws IOException { 
  print(message);
  return reader.readLine(); 
 }

 public int readInt() throws IOException
 { return Integer.parseInt(reader.readLine()); }

 public int readInt(String message) throws IOException { 
  print(message);
  return Integer.parseInt(reader.readLine()); 
 }

 public double readDouble() throws IOException
 { return Double.valueOf(reader.readLine()).doubleValue(); }

 public double readDouble(String message) throws IOException { 
  print(message);
  return Double.valueOf(reader.readLine()).doubleValue(); 
 }

 public char readChar() throws IOException
 { return (reader.readLine()).charAt(0); }

 public char readChar(String message) throws IOException { 
  print(message);
  return (reader.readLine()).charAt(0); 
 }

} // end class file

//////////////////////////////////////////////////////////////////////////
// End of file                                                          //
//////////////////////////////////////////////////////////////////////////

