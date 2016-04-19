package controller;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import databeans.Arrival;
import model.Model;

public class SearchAction extends Action {

	public SearchAction(Model model) {
	}

	public String getName() {
		return "search.do";
	}

	public String perform(HttpServletRequest request) {
		List<String> errors = new ArrayList<String>();
		errors.add("Errors!");
		request.setAttribute("errors", errors);

		String route = (String) request.getParameter("routeSelect");
		String stop = (String) request.getParameter("stopSelect");
		String direc = (String) request.getParameter("direction");
		System.out.println("route: "+route);
		System.out.println("stop: "+stop);

		URLConnection uc;
		try {
			uc = new URL(
					"http://realtime.portauthority.org/bustime/api/v1/getpredictions?key=zURTdnS6kJC63LSQ57i7RDJPu&rt="
							+ route + "&stpid=" + stop).openConnection();
			BufferedReader br = new BufferedReader(new InputStreamReader(
					uc.getInputStream()));

			BufferedWriter bw = new BufferedWriter(new FileWriter(new File(
					"search.xml")));

			String next;

			while ((next = br.readLine()) != null) {

				bw.write(next);
			}

			br.close();
			bw.close();

			String filename = "search.xml";
			try {
				DocumentBuilderFactory factory = DocumentBuilderFactory
						.newInstance();
				DocumentBuilder builder = factory.newDocumentBuilder();
				Document document = builder.parse(new File(filename));
				Element rootElement = document.getDocumentElement();
				int size = 0;
				NodeList list1 = rootElement.getElementsByTagName("tmstmp");
				size = list1.getLength();
				
				if(size == 0){
					HttpSession session  = request.getSession();
					String str= "No Available Arrivals Yet!";
					session.setAttribute("size", str);
					session.setAttribute("arrivalList", null);
					return "index.jsp#arrivals";
				}
				System.out.println("size: "+size);
				Element element = (Element) list1.item(0);
				String now = element.getChildNodes().item(0)
						.getNodeValue();
				ArrayList<Arrival> arrivalList = new ArrayList<Arrival>();
				for(int i = 0;i<size;i++){
					
					NodeList direList = rootElement.getElementsByTagName("rtdir");
					Element dir = (Element) direList.item(i);
					if(!dir.getChildNodes().item(0).getNodeValue().toLowerCase().equals(direc.toLowerCase())) continue;
					Arrival bus = new Arrival();
					bus.setRoute(route);
					System.out.println("here5!");
					NodeList list3 = rootElement.getElementsByTagName("prdtm");
					Element arrtime = (Element) list3.item(i);
					String arriveTime = arrtime.getChildNodes().item(0).getNodeValue();
					System.out.println("arriveTime: "+arriveTime);
					DateFormat df = new SimpleDateFormat("yyyyMMdd HH:mm");
					int leftTime = 0;
					try {
						Date d1 = df.parse(arriveTime);
						Date d2 = df.parse(now);
						leftTime = (int) ((d1.getTime() - d2.getTime())/60000);
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					bus.setTime(leftTime);
					arrivalList.add(bus);
					System.out.println(" "+bus.getRoute()+" "+bus.getTime());
				}
				if(arrivalList.size()==0){
					HttpSession session  = request.getSession();
					String str= "No Available Arrivals Yet!";
					session.setAttribute("size", str);
					session.setAttribute("arrivalList", null);
					return "index.jsp#arrivals";
				}
				String str = "Route / Destination";
				HttpSession session  = request.getSession();
				session.setAttribute("size", null);
				session.setAttribute("he", str);
				session.setAttribute("arrivalList", arrivalList);
				return "index.jsp#arrivals";

			} catch (Exception e) {
				System.out.println("exception:" + e.getMessage());
			}
		} catch (IOException e1) {

			e1.printStackTrace();
		}

		return "index.jsp#arrivals";
	}
}
