package config_pkg;

  parameter int AW = 4;  // Address Width
  parameter int DW = 20;  // Data Width
  parameter int CW = 4;  // Operation Code Width

  typedef logic [AW-1:0] addr_t; // Address Type
  typedef logic [DW-1:0] data_t; // Data Type
  typedef logic [2*DW-1:0] w_data_t; // Wide Data Type
  typedef logic [CW-1:0] code_t; // Code Type

  typedef struct packed {
    addr_t vrs1;
    addr_t vrs2;
    addr_t vrs3;
    code_t opcode;
  } uinstr_t;

endpackage
