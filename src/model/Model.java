package model;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;

import org.genericdao.ConnectionPool;
import org.genericdao.DAOException;

public class Model {

	public Model(ServletConfig config) throws ServletException, DAOException {
		String jdbcDriver = config.getInitParameter("jdbcDriverName");
		String jdbcURL    = config.getInitParameter("jdbcURL");
		
		ConnectionPool pool = new ConnectionPool(jdbcDriver,jdbcURL);
	}	
		
}
