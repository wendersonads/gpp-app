import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-filial-header',
  templateUrl: './filial-header.component.html',
  styleUrls: ['./filial-header.component.css']
})
export class FilialHeaderComponent implements OnInit {

  selectedItem = '2';

  constructor() { }

  ngOnInit(): void {
  }

}
