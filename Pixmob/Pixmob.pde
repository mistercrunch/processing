import controlP5.*;

int res = 20;
int screen_size = 400;

Pixel[][] pixel;
Spot spot;

ControlP5 menu;
MultiList shapes;
boolean menu_display = false;

void setup() {
	size(screen_size, screen_size);
	background(255);
	noStroke();
	smooth();
	
	pixel = new Pixel[res][res];
	
	spot = new Spot();

	for(int i = 0;i < res;i++) {
		for(int j = 0;j < res;j++) {
			pixel[i][j] = new Pixel(i*res,j*res,res);
		}
	}	
	
	menu = new ControlP5(this);
	shapes = menu.addMultiList("spot shapes",0,10,100,12);

	MultiListButton b;
	b = shapes.add("spot",0);
	b.add("round", 0).setLabel("round");
	b.add("half rect", 1).setLabel("half rect");
	b.add("full rect", 2).setLabel("full rect");
}

void draw() {
	background(255);
	
	if(!menu_display) menu.hide();
	else menu.show();
	
	for(int i = 0;i < res;i++) {
		for(int j = 0;j < res;j++) {
			pixel[i][j].draw();
		}
	}
	
	spot.draw();
}

void keyPressed() {
	if(key == '+') spot.sz += 10;
	else if(key == '-') spot.sz -= 10;
	else if(key == TAB) menu_display = !menu_display;
}


void controlEvent(ControlEvent event) {
  if(event.controller().name() == "spot shapes") spot.shape = int(event.value());  
  
}

class Pixel {
	int infra_pattern, bg_pattern = 0; 
	int xPos, yPos, sz;
	
	public Pixel(int x, int y, int s) {
		xPos = x;
		yPos = y;
		sz = s;
	}
	
	boolean isAddressed() {
		int centerX = xPos+sz/2;
		int centerY = yPos+sz/2;
		
		//spot shapes
		switch(spot.shape) {
			case 0:
				if((centerX >= mouseX - (spot.sz/2)) && (centerX <= mouseX + (spot.sz/2)) && (centerY <= mouseY + (spot.sz/2)) && (centerY >= mouseY - (spot.sz/2)) && spot.isOn()) return true;
				else return false;
			case 1:
				if((centerX >= mouseX - width/4) && (centerX <= mouseX + width/4) && (centerY <= mouseY + (spot.sz/2)) && (centerY >= mouseY - (spot.sz/2)) && spot.isOn()) return true;
				else return false;
			case 2:
				if((centerX >= mouseX - width/2) && (centerX <= mouseX + width/2) && (centerY <= mouseY + (spot.sz/2)) && (centerY >= mouseY - (spot.sz/2)) && spot.isOn()) return true;
				else return false;
			default:
				return false;
		}
		
	}
		
	
	void draw() {
		//to do if being exposed to mad infralights
		if(isAddressed()) {
			switch(infra_pattern) {
				case 0:
					fill(255);
					break;
				case 1:
					fill(0);
					break;
				default:
					break;
			}
		} else {			
			//pattern to do while not addressed
			switch(bg_pattern) {
				case 0:
					fill(0);
					break;
				case 1:
					fill(random(255), random(255), random(255));
					break;
				default:
					break;
			}
		}
		
		//pixel
		rect(xPos, yPos, sz, sz);
	}
}

class Spot {
	int sz = 50;
	int shape = 2;
	
	public Spot() {}
	
	boolean isOn() {
		if(mousePressed && !menu_display) return true;
		else return false;
	}
	
	void draw() {
		if(!isOn()) fill(255, 255, 255, 100	);
		else fill(123, 123, 123, 100);
		
		//spot shapes
		switch(shape) {
			case 0: 
				ellipse(mouseX, mouseY, sz, sz);
				break;
			case 1:
				rect(mouseX-width/4, mouseY-sz/2, width/2, sz);
				break;
			case 2:
				rect(mouseX-width/2, mouseY-sz/2, width, sz);
				break;
		}
	}
}
			
			
