module main(
	input clk,
	input[7:0]sw,
	input[3:0]bt,
	output[7:0]a_to_g,
	output[3:0]en,
	output reg[7:0]led);
	reg[3:0]a;
	reg[3:0]b;
	reg[3:0]c;
	reg[3:0]d;
	reg[3:0]dd;
	reg sa;
	reg sb;
	reg sc;
	reg sd;
	reg[2:0]sel=0;
	reg[31:0]ccnt;
	reg[5:0]h=0;
	reg[5:0]m=0;
	reg[5:0]s=0;
	reg[31:0]speed=50000000;
	reg[2:0]off=0;
	reg[3:0]h1;
	reg[3:0]h2;
	reg[3:0]m1;
	reg[3:0]m2;
	reg[3:0]s1;
	reg[3:0]s2;
	reg[31:0]waitb0=0;
	reg[31:0]waitb1=0;
	reg[31:0]waitb2=0;
	always@(posedge bt[3])
	begin
		sel=sel+1;
		if(sel==4)
			sel=0;
	end
	always@(posedge clk)
	begin
		if(waitb0>0)
			waitb0=waitb0-1;
		if(waitb1>0)
			waitb1=waitb1-1;
		if(waitb2>0)
			waitb2=waitb2-1;
		if(bt[2]==1&&waitb2==0)
		begin
			waitb2=0;
			if(sel==1)
			begin
				h=h+1;
				if(h==24)
					h=0;
			end
			if(sel==2)
			begin
				m=m+1;
				if(m==60)
					m=0;
			end
			if(sel==3)
			begin
				s=s+1;
				if(s==60)
					s=0;
			end
			waitb2=25000000;
		end
		if(bt[0]==1&&waitb0==0)
		begin
			if(off<2)
				off=off+1;
			waitb0=25000000;
		end
		if(bt[1]==1&&waitb1==0)
		begin
			if(off>0)
				off=off-1;
			waitb1=25000000;
		end
		if(sw[0]+sw[1]+sw[2]==0)
			speed=50000000;
		else if(sw[0]+sw[1]+sw[2]==2)
			speed=83333;
		else if(sw[0]+sw[1]+sw[2]==1)
			speed=1000000;
		else
			speed=400;
		ccnt=ccnt+1;
		if(ccnt>=speed)
		begin
			ccnt=0;
			s=s+1;
			if(s==60)
			begin
				s=0;
				m=m+1;
				if(m==60)
				begin
					m=0;
					h=h+1;
					if(h==24)
					begin
						h=0;
					end
				end
			end
		end
		led=0;
		if(s>5)
			led=led+32;
		if(s>15)
			led=led+16;
		if(s>25)
			led=led+8;
		if(s>35)
			led=led+4;
		if(s>45)
			led=led+2;
		if(s>55)
			led=led+1;
		led[7]=s%2;
		if(h<10)
		begin
			h1=0;
			h2=h;
		end
		else if(h<20)
		begin
			h1=1;
			h2=h-10;
		end
		else
		begin
			h1=2;
			h2=h-20;
		end
		if(m<10)
		begin
			m1=0;
			m2=m;
		end
		else if(m<20)
		begin
			m1=1;
			m2=m-10;
		end
		else if(m<30)
		begin
			m1=2;
			m2=m-20;
		end
		else if(m<40)
		begin
			m1=3;
			m2=m-30;
		end
		else if(m<50)
		begin
			m1=4;
			m2=m-40;
		end
		else
		begin
			m1=5;
			m2=m-50;
		end
		if(s<10)
		begin
			s1=0;
			s2=s;
		end
		else if(s<20)
		begin
			s1=1;
			s2=s-10;
		end
		else if(s<30)
		begin
			s1=2;
			s2=s-20;
		end
		else if(s<40)
		begin
			s1=3;
			s2=s-30;
		end
		else if(s<50)
		begin
			s1=4;
			s2=s-40;
		end
		else
		begin
			s1=5;
			s2=s-50;
		end
		//dd sa,sb,sc,sd a,b,c,d
		sa=0;
		sb=0;
		sc=0;
		sd=0;
		if(off==0)
		begin
			dd=4'b1010;
			if(sel==1)
			begin
				sa=1;
				sb=1;
			end
			if(sel==2)
			begin
				sc=1;
				sd=1;
			end
			a=h1;
			b=h2;
			c=m1;
			d=m2;
		end
		if(off==1)
		begin
			dd=4'b0101;
			if(sel==1)
			begin
				sa=1;
			end
			if(sel==2)
			begin
				sb=1;
				sc=1;
			end
			if(sel==3)
			begin
				sd=1;
			end
			a=h2;
			b=m1;
			c=m2;
			d=s1;
		end
		if(off==2)
		begin
			dd=4'b1010;
			if(sel==2)
			begin
				sa=1;
				sb=1;
			end
			if(sel==3)
			begin
				sd=1;
				sc=1;
			end
			a=m1;
			b=m2;
			c=s1;
			d=s2;
		end
	end
	digit digit(
		.clk(clk),
		.a(a),
		.b(b),
		.c(c),
		.d(d),
		.dd(dd),
		.sa(sa),
		.sb(sb),
		.sc(sc),
		.sd(sd),
		.a_to_g(a_to_g),
		.en(en));
endmodule
