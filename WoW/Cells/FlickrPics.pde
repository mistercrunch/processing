import java.io.IOException;
import processing.core.*;
import org.xml.sax.SAXException;
import com.aetrion.flickr.*;
import com.aetrion.flickr.contacts.*;
import com.aetrion.flickr.people.*;
import com.aetrion.flickr.FlickrException; 
import com.aetrion.flickr.photos.*;
import javax.xml.parsers.ParserConfigurationException;




//FlickPics fPic = new FlickPics({"clouds"},"b30b0348689790827bdfcfd8b64063bb", "81dee0709083d088");

class FlickPics
{
  Flickr f;
  int NbPics=200;
  PhotoList cacheResult;
  SearchParameters query;

  FlickPics(String [] tags, String apiKey, String keySecret)
  {
    try
    {
      query = new SearchParameters();
      f = new Flickr(apiKey, keySecret, new REST());
 
      query.setTags(tags); 
      query.setSort(SearchParameters.INTERESTINGNESS_DESC);
      PhotosInterface photosInterface = f.getPhotosInterface();
      cacheResult = photosInterface.search(query, NbPics, 1);
    }
    catch (IOException e) {System.out.println("IOExp:"+e.getMessage());} 
    catch (SAXException e)  {System.out.println("SAX:"+e.getMessage());} 
    catch (FlickrException e) {System.out.println("FlickrException:"+e.getMessage());} 
    catch (ParserConfigurationException e) {System.out.println("FlickrException:"+e.getMessage());}
  }
  PImage GetMediumRandPic()
  {
      PImage piMage;
      Photo p;
      p = (Photo) cacheResult.get((int)random(NbPics));
      piMage = loadImage(p.getMediumUrl());
      return piMage;
  }
  PImage GetLargeRandPic()
  {
      int tmpWidth=500;
      int tmpHeight=375;
      PImage piMage;
      Photo p;
      p = (Photo) cacheResult.get((int)random(NbPics));
      piMage = loadImage(p.getLargeUrl());
      tmpWidth = piMage.width;
      tmpHeight = piMage.height;
      
      while(tmpWidth==500 && tmpHeight==375)
      {
        p = (Photo) cacheResult.get((int)random(NbPics));
        piMage = loadImage(p.getLargeUrl());
        tmpWidth = piMage.width;
        tmpHeight = piMage.height;
      }
      
        
      return piMage;
  }
  String GetRandURL()
  {
    Photo p = (Photo) cacheResult.get((int)random(NbPics));
    return p.getLargeUrl();
  }
};
