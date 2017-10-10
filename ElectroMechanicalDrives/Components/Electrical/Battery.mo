within ElectroMechanicalDrives.Components.Electrical;
model Battery "Re-chargeable battery with internal resistor"
  parameter Integer ns(min = 1) = 1 "Number of series cells";
  parameter Integer np(min = 1) = 1 "Number of parallel cells";
  parameter Modelica.SIunits.Voltage V1Cell "Maximum cell voltage > V0Cell";
  parameter Modelica.SIunits.Voltage V0Cell "Minimum cell voltage < V1Cell";
  final parameter Modelica.SIunits.Voltage V1 = V1Cell*ns "Maximum battery voltage > V0";
  final parameter Modelica.SIunits.Voltage V0 = V0Cell*ns "Maximum battery voltage < V1";
  parameter Boolean allowOvercharge = false
    "Allows overcharging without error";
  parameter Boolean allowUndercharge = false
    "Allows undercharging without error";
  parameter Modelica.SIunits.Energy ECell
    "Total cell energy between V0Cell and V1Cell";
  final parameter Modelica.SIunits.Capacitance CCell = 2 * ECell / (V1Cell ^ 2 - V0Cell ^ 2)
    "Total charge of battery";
  parameter Modelica.SIunits.Resistance RCell "Cell resistance";
  parameter Modelica.SIunits.Voltage ViniCell = V1Cell "Initial cell voltage";
  Modelica.SIunits.Voltage v = pin_p.v - pin_n.v "Battery voltage";
  Modelica.SIunits.Voltage vCell = v / ns "Cell voltage";
  Modelica.SIunits.Current i = capacitor.i "Battery current";
  Modelica.SIunits.Current iCell = i / np "Cell current";
  Modelica.SIunits.Power power = v * i "Battery power";
  Modelica.SIunits.Power powerCell = power/ns/np "Cell power";
  Modelica.SIunits.Energy energy "Energy";
  Modelica.SIunits.Energy energyCell "Cell energy";
  Modelica.Electrical.Analog.Basic.Capacitor capacitor(final C = CCell * np / ns, v(start = ns * ViniCell, fixed = true)) annotation(Placement(transformation(extent = {{20, -10}, {40, 10}})));
  Modelica.Electrical.Analog.Interfaces.PositivePin pin_p "Positive pin"
                                                          annotation(Placement(transformation(extent = {{-110, -10}, {-90, 10}})));
  Modelica.Electrical.Analog.Interfaces.NegativePin pin_n "Negative pin"
                                                          annotation(Placement(transformation(extent = {{90, -10}, {110, 10}})));
  Modelica.Electrical.Analog.Basic.Resistor resistor(R = RCell * ns / np) annotation(Placement(transformation(extent = {{-40, -10}, {-20, 10}})));
initial equation
  energyCell = CCell * (ViniCell ^ 2 - V0Cell ^ 2) / 2;
equation
  der(energy) = power;
  energyCell * ns * np = energy;
  assert(vCell >= V0Cell or allowUndercharge, "Battery: cell voltage less than V0Cell");
  assert(vCell <= V1Cell or allowOvercharge, "Battery: cell voltage greater than V1Cell");
  connect(capacitor.n, pin_n) annotation(Line(points = {{40, 0}, {56, 0}, {56, 4.44089e-16}, {100, 4.44089e-16}}, color = {0, 0, 255}, smooth = Smooth.None));
  connect(pin_p, resistor.p) annotation(Line(points = {{-100, 0}, {-40, 0}}, color = {0, 0, 255}, smooth = Smooth.None));
  connect(resistor.n, capacitor.p) annotation(Line(points = {{-20, 0}, {20, 0}}, color = {0, 0, 255}, smooth = Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}})),           Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Text(extent = {{-50, 82}, {40, 32}}, lineColor = {0, 0, 255}, textString = "+"), Line(points = {{-20, 0}, {20, 0}}, color = {0, 0, 255}), Line(points = {{20, 60}, {20, -60}}, color = {0, 0, 255}), Line(points = {{40, 30}, {40, -30}}, color = {0, 0, 255}), Line(points = {{40, 0}, {90, 0}}, color = {0, 0, 255}), Text(extent = {{20, 50}, {120, 0}}, lineColor = {0, 0, 255}, textString = "-"), Rectangle(extent = {{-20, -12}, {-70, 12}}, lineColor = {0, 0, 255}), Line(points = {{-70, 0}, {-90, 0}}, color = {0, 0, 255}, smooth = Smooth.None), Text(extent = {{-150, 140}, {150, 100}}, lineColor = {0, 0, 255}, textString = "%name")}),
    Documentation(info="<html>
<p>This linear battery model is based on a linear capacitor which can be charged and discharged. 
The battery cell is parameterized by the upper and lower operationg voltage limit and the total
energy content <code>ECell</code> which is accessible for <code>V0cell &le; vCell &le; V1Cell</code>.
By default the battery starts fully charged. The battery internal resistance <code>RCell</code> is considered.
</p>

<p>By default an assert is triggered with the battery is overcharged oder undercharged. 
These asserts can be avoided by setting the parameters <code>allowOvercharge</code> 
and <code>allowUndercharge</code> to <code>true</code>.</p>
</html>"));
end Battery;
