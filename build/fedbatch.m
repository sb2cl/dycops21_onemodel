classdef fedbatch
	% This file was automatically generated by OneModel.
	% Any changes you make to it will be overwritten the next time
	% the file is generated.

	properties
		p      % Default model parameters.
		x0     % Default initial conditions.
		M      % Mass matrix for DAE systems.
		opts   % Simulation options.
	end

	methods
		function obj = fedbatch()
			%% Constructor of fedbatch.
			obj.p    = obj.default_parameters();
			obj.x0   = obj.initial_conditions();
			obj.M    = obj.mass_matrix();
			obj.opts = obj.simulation_options();
		end

		function p = default_parameters(~)
			%% Default parameters value.
			p = [];
			p.m_p = 433.0;
			p.K_s = 0.1802;
			p.bio__y = 0.45;
			p.bio__s_f = 180.156;
			p.bio__nOD = 1.0;
		end

		function x0 = initial_conditions(~)
			%% Default initial conditions.
			x0 = [
				1.0 % bio__V
				0.0 % bio__V_feed
				0.0 % bio__V_out
				0.05 % bio__N
				3.6 % bio__s
				0.0 % bio__S
			];
		end

		function M = mass_matrix(~)
			%% Mass matrix for DAE systems.
			M = [
				1 0 0 0 0 0 
				0 1 0 0 0 0 
				0 0 1 0 0 0 
				0 0 0 1 0 0 
				0 0 0 0 1 0 
				0 0 0 0 0 1 
			];
		end

		function opts = simulation_options(~)
			%% Default simulation options.
			opts.t_end = 1000.0;
			opts.t_init = 0.0;
		end

		function dx = ode(~,t,x,p)
			%% Evaluate the ODE.
			%
			% Args:
			%	 t Current time in the simulation.
			%	 x Array with the state value.
			%	 p Struct with the parameters.
			%
			% Return:
			%	 dx Array with the ODE.

			% ODE and algebraic states:
			bio__V = x(1,:);
			bio__V_feed = x(2,:);
			bio__V_out = x(3,:);
			bio__N = x(4,:);
			bio__s = x(5,:);
			bio__S = x(6,:);

			% Assigment states:
			bio__m_p = p.m_p;
			bio__mu = (log10(2)./24).*bio__s./(bio__s + p.K_s);
			bio__F_out = 0;
			bio__x = bio__N.*bio__m_p.*1e-3;
			bio__OD = bio__N./p.bio__nOD;
			bio__F_in = (1./p.bio__y).*bio__mu.*bio__x.*bio__V./(p.bio__s_f - bio__s);

			% der(bio__V)
			dx(1,1) = bio__F_in - bio__F_out;

			% der(bio__V_feed)
			dx(2,1) = bio__F_in;

			% der(bio__V_out)
			dx(3,1) = bio__F_out;

			% der(bio__N)
			dx(4,1) = bio__mu.*bio__N - (bio__F_in./bio__V).*bio__N;

			% der(bio__s)
			dx(5,1) = (bio__F_in./bio__V).*(p.bio__s_f - bio__s) - (1./p.bio__y).*bio__mu.*bio__x;

			% der(bio__S)
			dx(6,1) = bio__F_out.*bio__s;

		end
		function out = simout2struct(~,t,x,p)
			%% Convert the simulation output into an easy-to-use struct.

			% We need to transpose state matrix.
			x = x';
			% ODE and algebraic states:
			bio__V = x(1,:);
			bio__V_feed = x(2,:);
			bio__V_out = x(3,:);
			bio__N = x(4,:);
			bio__s = x(5,:);
			bio__S = x(6,:);

			% Assigment states:
			bio__m_p = p.m_p;
			bio__mu = (log10(2)./24).*bio__s./(bio__s + p.K_s);
			bio__F_out = 0;
			bio__x = bio__N.*bio__m_p.*1e-3;
			bio__OD = bio__N./p.bio__nOD;
			bio__F_in = (1./p.bio__y).*bio__mu.*bio__x.*bio__V./(p.bio__s_f - bio__s);

			% Save simulation time.
			out.t = t;

			% Vector for extending single-value states and parameters.
			ones_t = ones(size(t'));


			% Save states.
			out.bio__m_p = bio__m_p.*ones_t;
			out.bio__mu = bio__mu.*ones_t;
			out.bio__F_in = bio__F_in.*ones_t;
			out.bio__F_out = bio__F_out.*ones_t;
			out.bio__V = bio__V.*ones_t;
			out.bio__V_feed = bio__V_feed.*ones_t;
			out.bio__V_out = bio__V_out.*ones_t;
			out.bio__N = bio__N.*ones_t;
			out.bio__x = bio__x.*ones_t;
			out.bio__OD = bio__OD.*ones_t;
			out.bio__s = bio__s.*ones_t;
			out.bio__S = bio__S.*ones_t;

			% Save parameters.
			out.m_p = p.m_p.*ones_t;
			out.K_s = p.K_s.*ones_t;
			out.bio__y = p.bio__y.*ones_t;
			out.bio__s_f = p.bio__s_f.*ones_t;
			out.bio__nOD = p.bio__nOD.*ones_t;

		end
		function plot(~,out)
			%% Plot simulation result.
			figure('Name','bio');
			subplot(4,3,1);
			plot(out.t, out.bio__m_p);
			title("bio__m_p");
			ylim([0, +inf]);
			grid on;

			subplot(4,3,2);
			plot(out.t, out.bio__mu);
			title("bio__mu");
			ylim([0, +inf]);
			grid on;

			subplot(4,3,3);
			plot(out.t, out.bio__F_in);
			title("bio__F_in");
			ylim([0, +inf]);
			grid on;

			subplot(4,3,4);
			plot(out.t, out.bio__F_out);
			title("bio__F_out");
			ylim([0, +inf]);
			grid on;

			subplot(4,3,5);
			plot(out.t, out.bio__V);
			title("bio__V");
			ylim([0, +inf]);
			grid on;

			subplot(4,3,6);
			plot(out.t, out.bio__V_feed);
			title("bio__V_feed");
			ylim([0, +inf]);
			grid on;

			subplot(4,3,7);
			plot(out.t, out.bio__V_out);
			title("bio__V_out");
			ylim([0, +inf]);
			grid on;

			subplot(4,3,8);
			plot(out.t, out.bio__N);
			title("bio__N");
			ylim([0, +inf]);
			grid on;

			subplot(4,3,9);
			plot(out.t, out.bio__x);
			title("bio__x");
			ylim([0, +inf]);
			grid on;

			subplot(4,3,10);
			plot(out.t, out.bio__OD);
			title("bio__OD");
			ylim([0, +inf]);
			grid on;

			subplot(4,3,11);
			plot(out.t, out.bio__s);
			title("bio__s");
			ylim([0, +inf]);
			grid on;

			subplot(4,3,12);
			plot(out.t, out.bio__S);
			title("bio__S");
			ylim([0, +inf]);
			grid on;

		end
	end
end